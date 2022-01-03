//
//  VFGRootViewController.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 03.01.2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 View controller which should be a root view controller of the application. Provides top bar and navigation buttons.
 All view controllers should be added to its `containerNavigationController`
 */

@objc public enum BubbleColor: Int {
    case red = 0
    case white
}

internal struct VFGRootViewConst {
    static let embedSegue = "embedNavigationController"
    static let animationDuration = 0.2
    static let animationDurationTime: TimeInterval = 0.5
    static let offlineRibbonTopMargin: CGFloat = 25.0
}

open class VFGRootViewController: UIViewController {

    /**
     * Keeping track of number of view controllers inside the navigation stack
     */
    var navigationControllerCounter: Int = 0
    /**
     * Enum value to set the background color of the VFGNeedHelp floating bubble, default value is **White**
     */
    @objc public var floatingBubbleColor: BubbleColor = .white {
        didSet {
            updateBubble()
        }
    }

    // MARK: - Private Instance Constants
    static var componentsFactory: VFGRootViewControllerComponents = VFGRootViewControllerComponents()

    /**
     Top Bar containing navigation buttons.
     */
    @IBOutlet public weak var topBar: VFGTopBar!
    /// this variable is added so topbar will hide behind it when gets scrolled up
    /// in devices older than iphonx
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var blackOverlayView: UIView!
    @IBOutlet weak var nudgeView: VFGNudgeView!
    @IBOutlet weak var nudgeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpacingNudgeAndTopBar: NSLayoutConstraint!
    public var shouldNudgeView: Bool = false

    public var isStatusBarHidden: Bool = false {
        didSet(newValue) {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    /**
     Side menu which is presented when user clicks on menu button.
     */
    @objc public internal(set) lazy var sideMenu: VFGSideMenuViewController = {
        return VFGRootViewController.componentsFactory.sideMenuViewController(inViewController: self)
    }()

    @objc public var floatingBubble: VFGFloatingBubbleView?

    private lazy var statusBarManager: VFGRootViewStatusBarManager = {
        return VFGRootViewController.componentsFactory.statusBarManager()
    }()

    @objc public var containerNavigationController: VFGNavigationController!

    // property to check if offline ribbon is visible
    @objc public var isOfflineRibbonVisible: Bool = false

    internal var currentTopBarScrollState: VFGTopBarScrollState {
        return contentTopBarScrollState ?? defaultTopBarScrollState
    }
    private weak var contentTopBarScrollState: VFGTopBarScrollState?
    private var defaultTopBarScrollState: VFGTopBarScrollState = VFGTopBarScrollState()
    internal var previousTopBarScrollState: VFGTopBarScrollState?

    private var topBarTransitionInProgress: Bool = false

    /**
     Defines appearance of status bar background.
     */
    public var statusBarState: VFGRootViewControllerStatusBarState {
        get {
            return statusBarManager.statusBarState
        }
        set {
            VFGDebugLog("new statusBarState:\(newValue)")
            statusBarManager.statusBarState = newValue
        }
    }

    @objc public var statusBarAlpha: CGFloat {
        get {
            return statusBarManager.alpha
        }
        set {
            statusBarManager.alpha = newValue
        }
    }

    /**
     This property returns singleton instance of root view controller.
     */
    @objc public static let shared: VFGRootViewController = {
        let rootViewController = UIViewController.rootViewController()
        rootViewController.loadViewIfNeeded()
        return rootViewController
    }()

    @objc override open func viewDidLoad() {
        super.viewDidLoad()
        nudgeView.isHidden = true
        blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackOverlayView.alpha = 0
        topBar.rightButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        topBar.leftButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        statusBarManager.statusBarBackgroundView = statusBarBackgroundView
    }

    @objc override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if nudgeView.isHidden {
            configureNudgeHeightConstraint()
        }
    }

    @objc open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !topBarTransitionInProgress {
            refreshTopBar()
        }
        sideMenu.layoutMenu()
        view.bringSubviewToFront(sideMenu.view)

        if UIScreen.hasNotch {
            statusBarHeightConstraint.constant = 44
        }
    }

    @objc open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTopBar()
    }

    @objc override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == VFGRootViewConst.embedSegue,
            let destinationViewController = segue.destination as? VFGNavigationController else {
            return
        }
        containerNavigationController = destinationViewController
    }

    @objc public var backTapClosure : (() -> Void)?
    @objc public var showNudgeClosure : (() -> Void)?
    @objc public var hideNudgeClosure : (() -> Void)?

    //This function layouts the topConstraint of the topbar to nudge or to topLayoutGuide relative to nudge status
    @objc internal func configureVerticalSpacingTopBar(willShowNudge: Bool) {
        var item: Any?
        if willShowNudge {
            item = nudgeView
        } else {
            item = topLayoutGuide
        }
        verticalSpacingNudgeAndTopBar = NSLayoutConstraint(item: topBar,
                                                           attribute: .top,
                                                           toItem: item,
                                                           attribute: .bottom,
                                                           constant: 0)
    }

    // Method to configure the constraint height for nudge,
    // If device not iPhoneX, the container view will begin after the status bar.
    internal func configureNudgeHeightConstraint() {
            if !UIScreen.hasNotch {
                nudgeViewHeightConstraint.constant = VFGCommonUISizes.statusBarHeight
            } else {
                nudgeViewHeightConstraint.constant = 0
            }
    }

    @objc private func menuTapped() {
        refreshTopBar()
        VFGDebugLog("Menu tapped")
        hideNudgeViewTemp()
        self.sideMenu.showMenu(withAnimation: true)
        self.sideMenu.hideMenu()
        self.sideMenu.hideMenuBackground = { [weak self]  in
            guard let `self` = self else { return }
            if self.shouldNudgeView {
                self.showNudge()
            }
            self.refreshTopBar()
        }
    }

    @objc private func backTapped() {
        // check navigation controller counter to determine if still using same sidemenuitem
        if containerNavigationController.viewControllers.count <= 2 {
            sideMenu.clearLastSelectedMenuItem()
        }
        VFGDebugLog("Back tapped")
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if let backTapClosure : () -> Void = self.backTapClosure {
                VFGDebugLog("Calling backTapClousure")
                backTapClosure()
            } else {
                self.popViewController(animated: true)
            }
            self.sideMenu.changeCurrentViewController()
            self.statusBarAlpha = self.previousTopBarScrollState?.getStatusBarAlpha() ?? 0
            self.previousTopBarScrollState = nil
        }
    }
}

// MARK: UI
extension VFGRootViewController {

    internal func topBarTransition(_ isOffsetEnabled: Bool?) {
        let fromIsNoOffset: Bool = isOffsetEnabled ?? true
        let shouldAnimateTansition = fromIsNoOffset != offsetEnabled()
        let hideTopBarBlock : (() -> Void) = { () -> Void in
            self.topBar.frame = CGRect(x: 0, y: -VFGTopBar.topBarHeight,
                                       width: UIScreen.main.bounds.width, height: VFGTopBar.topBarHeight)
            self.topBar.opaqueBackgroundAlpha = 0
        }
        let showTopBarBlock : (() -> Void) = { () -> Void in
            self.refreshTopBar()
            self.topBarTransitionInProgress = false
        }
        let hideTopBarCompletion: ((Bool) -> Void) = { (result) -> Void in
            self.animate(animations: showTopBarBlock, completion: nil)
        }
        topBarTransitionInProgress = true
        if shouldAnimateTansition {
            animate(animations: hideTopBarBlock, completion: hideTopBarCompletion)
        } else {
            showTopBarBlock()
        }
    }

    private func animate(animations: @escaping  () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: VFGRootViewConst.animationDuration,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: animations,
                       completion: completion)
    }

    private func configureTopBarState(_ viewController: UIViewController?) {
        if let controller = viewController as? VFGViewControllerContent {
            VFGDebugLog("Configure new topBarScrollState")
            contentTopBarScrollState = controller.topBarScrollState
            currentTopBarScrollState.topBar = topBar
        } else {
            contentTopBarScrollState = nil
        }
    }

    internal func updateTopBar(_ viewController: UIViewController?) {
        configureTopBarState(viewController)
        updateStatusBar(viewController)
        updateTopBarBackButton()
        updateTopBarTitle(viewController)
        updateRightBarButton(viewController)
        updateRightBarButtonIcon(viewController)
        updateLeftBarButtonIcon(viewController)
        updateTitleFont(viewController)
        updateTitleColor(viewController)
        updateParallaxEffectForBar(viewController)
        updateBackgroundColorBar(viewController)
        updateBubble()
        let initialY: CGFloat = shouldNudgeView ? nudgeView.currentHeight : VFGCommonUISizes.statusBarHeight
        currentTopBarScrollState.topBarInitialY = initialY
    }

    private func updateStatusBar(_ viewController: UIViewController?) {
        if viewController is VFGViewControllerContent {
            let statusBarState = (viewController as? VFGViewControllerContent)?.statusBarState
            statusBarManager.statusBarState = statusBarState ?? .black
        }
    }

    private func updateRightBarButton(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.rightButton.isHidden = contentViewController.topBarRightButtonHidden
        }
    }

    private func updateRightBarButtonIcon(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.rightButtonIconColor = contentViewController.rightButtonIconColor()
        }
    }

    private func updateLeftBarButtonIcon(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.leftButtonIconColor = contentViewController.leftButtonIconColor()
        }
    }

    private func updateTitleFont(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.titleFont = contentViewController.titleFont()
        }
    }

    private func updateTitleColor(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.titleColor = contentViewController.titleColor()
        }
    }

    private func updateBackgroundColorBar(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.opaqueBackgroundColor = contentViewController.backgroundColor()
            statusBarManager.customizedBarBGColor = contentViewController.backgroundColor()
        }
    }

    private func updateParallaxEffectForBar(_ viewController: UIViewController?) {
        if let contentViewController = viewController as? VFGViewControllerContent {
            topBar.parallaxEffectEnabled = contentViewController.parallaxEffectEnabled()
            statusBarManager.parallaxEffectEnabled = contentViewController.parallaxEffectEnabled()
        }
    }

    private func updateTopBarBackButton() {
        topBar.leftButton.isHidden = containerNavigationController.viewControllers.count <= 1
    }

    private func updateBubble() {
        switch floatingBubbleColor {
        case .white:
            floatingBubble?.setSecondLevel(false)
        case .red:
            floatingBubble?.setSecondLevel(true)
        }
        if let isFloatingBubbleInNotificationState = floatingBubble?.isFloatingBubbleInNotificationState() {
            floatingBubble?.setHasNewNotification(isFloatingBubbleInNotificationState)
        }
    }

    private func updateTopBarTitle(_ viewController: UIViewController?) {
        if let viewControllerContent = viewController as? VFGViewControllerContent {
            topBar.title = viewControllerContent.topBarTitle
        }
    }

    internal func refreshTopBar() {
        currentTopBarScrollState.refresh()
    }

    internal func offsetEnabled() -> Bool {
        return currentTopBarScrollState.isNoOffset
    }

    public func currentPage() -> String {
        if navigationControllerCounter >= 1 {
            guard let title = containerNavigationController.viewControllers.last?.title else {
                return ""
            }
            return title
        }
        return ""
    }

    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
