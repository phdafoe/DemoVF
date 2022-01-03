//
//  VFGPullToRefreshControl.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils
import SystemConfiguration

public typealias VFGPullToRefreshAction = () -> Void
public typealias VFGPullToRefreshOfflineAction = () -> Void

internal protocol VFGPullToRefreshAnimatable {
    func animate(state: State)
}

//
@objc open class VFGPullToRefreshControl: NSObject {
    /// Namespaces all the notifications related to **pull to refresh** control.
    static let rawNotification = "com.vodafone.VFGCommonUI.VFGPullToRefreshControl.Notification.didEndRefreshing"
    public enum Notification {
        /// Notification sent once the **pull to refresh** control ends refreshing.
        public static let didEndRefreshing: NSNotification.Name = NSNotification.Name(rawValue: rawNotification)
    }

    internal let reachability: VFGReachability = VFGReachability()!

    let refreshableView: VFGPullToRefreshAnimatableView
    let offlineRibbonView: VFGOfflineRibbonView

    internal var hasConnection: Bool = true
    internal var offsetObservation: NSKeyValueObservation?
    internal var insetObservation: NSKeyValueObservation?

    var action: (VFGPullToRefreshAction)?
    public var offlineAction: (VFGPullToRefreshOfflineAction)?

    weak var scrollView: UIScrollView? {
        willSet {
            removeScrollViewObserving()
        }
        didSet {
            if let scrollView = scrollView {
                scrollViewDefaultInsets = scrollView.contentInset
                addScrollViewObserving()
            }
        }
    }

    fileprivate var isObserving = false

    // MARK: - Timeframe Control (and Offline Ribbon message configuration)

    /// Used to configure the *last update* info displayed by the *off line ribbon*.
    public lazy var timeframeControl: VFGTimeframeControl = {
        VFGTimeframeControl(timeframes: [])
    }()

    /// Used to properly display the **last update** message in the *offline ribbon*.
    /// Probably it should be set from any *persistence system* (such as `UserDefaults`, `CoreDarta`, etc.)
    /// implemented by the local markets.
    @objc open var lastUpdate: Date?

    /// The message to display when data *has never been updated*. The default value is **Never**.
    @objc public var nerverUpdatedMessage: String = "Never"

    /// Builds the message to be displayed by the offline ribbon.
    /// The message is built based on `lastUpdate`, `nerverUpdatedMessage` and `timeframeControl` values.
    ///
    /// If there is no value available for `lastUpdate`, it will return the value set for `nerverUpdatedMessage`,
    /// otherwise, it will return the string resolved by the `timeframeControl` configuration.
    @objc open var lastUpdateMessage: String {
        guard let lastUpdate = lastUpdate else {
            return nerverUpdatedMessage
        }
        return timeframeControl.string(forDate: lastUpdate)
    }

    // MARK: - ScrollView
    var scrollViewDefaultInsets: UIEdgeInsets = .zero
    fileprivate var previousScrollViewOffset: CGPoint = .zero

    // MARK: - State
    var state: State = .initial {
        didSet {
            animate(state: state)
            switch state {
            case .offline:
                offlineRibbonView.frame.origin.y = -offlineRibbonView.frame.height
                offlineRibbonView.shake()
            case .loading:
                VFGRootViewController.shared.isOfflineRibbonVisible = false
                if oldValue != .loading { animateLoadingState() }
            case .finished:
                NotificationCenter.default.post(name: Notification.didEndRefreshing, object: self)
            default:
                break
            }
        }
    }

    // MARK: - Life Cycle
    @objc public override init() {
        let refreshableView = VFGPullToRefreshAnimatableView()
        refreshableView.translatesAutoresizingMaskIntoConstraints = false
        refreshableView.autoresizingMask = [.flexibleHeight]
        self.refreshableView = refreshableView
        offlineRibbonView = VFGOfflineRibbonView()
        super.init()
        offlineRibbonView.setErrorIcon()
        offlineRibbonView.setOfflineMessage()
        offlineRibbonView.setRefreshIcon()
        offlineRibbonView.setLastUpdateMessage()
        setupNotificationObservers()
        offlineRibbonView.delegate = self
    }

    deinit {
        scrollView?.removePullToRefreshControl()
        removeScrollViewObserving()
    }
}

// MARK: - VFGPullToRefreshAnimatable
extension VFGPullToRefreshControl: VFGPullToRefreshAnimatable {
    func animate(state: State) {
        switch state {
        case .initial:
            refreshableView.setInitialAnimationState()
        case .dragging(let progress):
            refreshableView.performDraggingUpdates(with: progress)
        case .offline:
            offlineRibbonView.showOfflineRibbon(withMessage: lastUpdateMessage)
            offlineAction?()
        case .loading:
            if !hasConnection {
                self.state = .offline
            } else {
                loadingIfOfflineRibonVisible()
                refreshableView.performLoadingAnimation()
            }
        case .finished:
            refreshableView.performFinishedAnimation({ [weak self] (didFinish) in
                guard let `self` = self else { return }
                if UIApplication.shared.applicationState != .active {
                    self.scrollView?.contentInset = self.scrollViewDefaultInsets
                    self.state = .initial
                } else if didFinish {
                    self.state = .initial
                    self.animateFinishedState()
                }
            })
        case .failedWithErrorMessage(let message):
            offlineRibbonView
                .showOfflineRibbon(withMessage: lastUpdateMessage,
                                   failureMessage: message)
            self.state = .initial
        }
    }

    func loadingIfOfflineRibonVisible() {
        if self.offlineRibbonView.isVisible {
            offlineRibbonView.showOnlineRibbon()
        }
    }
}

// MARK: - Key-Value Observing (Scroll View)
extension VFGPullToRefreshControl {
    private func configureState(isDragging: Bool) {
        let offset: CGFloat = previousScrollViewOffset.y + scrollViewDefaultInsets.top
        switch offset {
        case 0 where isNotLoadingAndNotFinished:
            state = .initial
        case -pullableHeight() ... 0 where isNotLoadingAndNotFinished:
            var progress = -offset / pullableHeight()
            refreshableView.animationContainer.backgroundColor = .clear
            if progress < 0.01 {
                progress = -1
                refreshableView.animationContainer.backgroundColor = .black
            }
            state = .dragging(progress: progress)
        case -CGFloat.greatestFiniteMagnitude ... -pullableHeight():
            if state == .dragging(progress: 1) && isDragging == false {
                state = hasConnection ? .loading : .offline
            } else if isNotLoadingAndNotFinished {
                state = .dragging(progress: 1)
            }
        default:
            break
        }
    }

    private var isNotLoadingAndNotFinished: Bool {
        return state != .loading && state != .finished
    }

    fileprivate func pullableHeight() -> CGFloat {
        return RefreshableView.height +
            (reachability.connection != .none ?
                OfflineRibbonView.heightZero : OfflineRibbonView.height)
    }

    fileprivate func addScrollViewObserving() {

        guard let scrollView = scrollView, !isObserving else { return }
        isObserving = true
        offsetObservation = scrollView.observe(\.contentOffset,
                                               options: [.initial, .new]) {[weak self] (scrollView, _) in
            guard let `self` = self else {
                return
            }
            self.configureState(isDragging: scrollView.isDragging)
            self.previousScrollViewOffset.y = scrollView.normalizedContentOffset.y

        }
        insetObservation = scrollView.observe(\.contentInset,
                                              options: [.initial, .new]) {[weak self] (scrollView, change) in
            guard let `self` = self else {
                return
            }
            if self.state == .initial {
                if let changedInset = change.newValue {
                    self.scrollViewDefaultInsets = changedInset
                }
            }
            self.previousScrollViewOffset.y = scrollView.normalizedContentOffset.y
        }
    }

    fileprivate func removeScrollViewObserving() {
        offsetObservation?.invalidate()
        insetObservation?.invalidate()
        isObserving = false
    }
}

// MARK: - VFGOfflineRibbon Delegate
extension VFGPullToRefreshControl: VFGOfflineRibbonDelegate {
    func offlineRibbonWillAppear() {
        guard let scrollView = scrollView else {
            return
        }

        var offsetY: CGFloat = -OfflineRibbonView.height - scrollViewDefaultInsets.top

        if UIScreen.hasNotch {
            offsetY -= VFGCommonUISizes.statusBarHeight
        }
        if scrollView.contentInset.top != -offsetY {
            UIView.animate(withDuration: View.resetScrollViewTopInsetDuration) {
                self.previousScrollViewOffset.y = offsetY
                scrollView.contentOffset.y = offsetY
                scrollView.contentInset.top = -offsetY
                let insetY = OfflineRibbonView.height
                if self.refreshableView.frame.origin.y < -insetY {
                    self.resetTopOfRefreshableView(to: -insetY)
                }
            }
        }
    }

    func offlineRibbonWillDisappear() {
        guard let scrollView = scrollView else {
            return
        }

        var offsetY: CGFloat = scrollView.contentOffset.y + OfflineRibbonView.height +
            scrollViewDefaultInsets.top

        if #available(iOS 11, *) {
            offsetY -= scrollView.safeAreaInsets.top
        }
        switch state {
        case .finished:
            offsetY = scrollView.contentOffset.y + OfflineRibbonView.height + scrollViewDefaultInsets.top +
                RefreshableView.height

            DispatchQueue.main.asyncAfter(deadline: .now() + SuccessTick.duration,
                                          execute: {
                scrollView.contentOffset.y = offsetY
                scrollView.contentInset.top = -offsetY
                self.offlineRibbonView.heightConstraint.constant = OfflineRibbonView.heightZero
            })
        case .initial:
            scrollView.contentOffset.y = self.scrollViewDefaultInsets.top
            scrollView.contentInset.top = self.scrollViewDefaultInsets.top
            self.offlineRibbonView.heightConstraint.constant = OfflineRibbonView.heightZero
        default:
            scrollView.contentOffset.y = offsetY
            scrollView.contentInset.top = -offsetY
            self.offlineRibbonView.heightConstraint.constant = OfflineRibbonView.heightZero
        }
    }
}

// MARK: - Scrolling animations
private extension VFGPullToRefreshControl {
    func animateLoadingState() {
        guard let scrollView = scrollView else {
            return
        }
        scrollView.bounces = false
        let insetY = RefreshableView.height + scrollViewDefaultInsets.top +
            (!offlineRibbonView.isVisible ? 0.0 : OfflineRibbonView.height)

        if refreshableView.frame.origin.y < -insetY {
            resetTopOfRefreshableView(to: -insetY)
        }
        UIView.animate(withDuration: LoadingState.duration,
            animations: {
                if self.refreshableView.frame.origin.y < -insetY {
                    self.resetTopOfRefreshableView(to: -insetY)
                }
                scrollView.contentInset.top = insetY
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insetY)
                self.refreshableView.layoutIfNeeded()
                self.refreshableView.superview?.layoutIfNeeded()
            },
            completion: { _ in
                self.refreshableView.animationView.layoutIfNeeded()
                self.refreshableView.animationContainer.layoutIfNeeded()
                scrollView.bounces = true
            }
        )
        action?()
    }

    func animateFinishedState() {
        removeScrollViewObserving()
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.bounces = false
        UIView.animate(
            withDuration: FinishedState.duration,
            delay: FinishedState.delay,
            options: FinishedState.animationOptions,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.scrollView?.contentInset.top = 0
                self.scrollView?.contentInset = self.scrollViewDefaultInsets
                self.refreshableView.layoutIfNeeded()
                self.refreshableView.superview?.layoutIfNeeded()
                self.refreshableView.animationView.layoutIfNeeded()
                self.refreshableView.animationContainer.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                guard let `self` = self else { return }
                if finished {
                    self.addScrollViewObserving()
                    self.state = .initial
                }
                self.scrollView?.bounces = true
            }
        )
    }
}

// MARK: - Helpers
private extension VFGPullToRefreshControl {
    var isVisible: Bool {
        guard let scrollView = scrollView else { return false }
        return (scrollView.normalizedContentOffset.y <= -scrollViewDefaultInsets.top)
    }

    func resetTopOfRefreshableView(to offset: CGFloat) {
        refreshableView.frame.origin.y = offset
        refreshableView.layoutIfNeeded()
        refreshableView.superview?.layoutIfNeeded()
    }
}

// MARK: - OfflineReibbon Visibility
public extension VFGPullToRefreshControl {
    var isOfflineRibbonVisible: Bool {
        return offlineRibbonView.isVisible
    }
}
