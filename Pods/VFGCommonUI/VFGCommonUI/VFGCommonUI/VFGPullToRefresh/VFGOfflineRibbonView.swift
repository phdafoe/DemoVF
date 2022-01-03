//
//  VFGOfflineRibbonView.swift
//  VFGCommonUI
//
//  Created by MOBICAMX38 on 1/31/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/*
 *  Constants used for the RibbonView based on the RefreshableView from
 *  VFGPullToRefreshControl and Design specifications
 */

enum View {
    static let rect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 51 )
    static let visibleAlpha: CGFloat = 1.0
    static let invisibleAlpha: CGFloat = 0.0
    static let hideRibbonDelay: Double = 3.4
    static let showRibbonAnimationDuration: TimeInterval = 0
    static let resetScrollViewTopInsetDuration: TimeInterval = 0.08
}

enum ErrorIcon {
    static let rect: CGRect = CGRect(x: 16, y: 11, width: 29, height: 29)
    static let imageName = "errorCircle"
    static let leadingDistance = 16
    static let topDistance = 11
}

enum AnimationEnum: String {
    case successTickOffline = "offline_success_tick_green"
    static let scaleXtransformation: CGFloat = 1.5
    static let scaleYtransformation: CGFloat = 1.5

    static func composition(for animation: AnimationEnum) -> Animation? {
        return Animation.named(animation.rawValue, bundle: Bundle.vfgCommonUI)
    }
}

enum RefreshArrow {
    static let rect: CGRect = CGRect(x: 332, y: 14, width: 29, height: 23)
    static let imageName = "refresh"
    static let trailingDistance = 14
    static let topDistance = 14
}

enum NetworkStatus {
    static let rect: CGRect = CGRect(x: 52, y: 20, width: 81, height: 12)
    static let trailingDistance = 7
    static let topDistance = 15
    static let offlineText = "You're offline"
    static let onlineText = "You're back online"
}

enum LastUpdate {
    static let rect: CGRect = CGRect(x: 203, y: 20, width: 123, height: 13)
    static let trailingDistance = 16
    static let topDistance = 16
}

protocol VFGOfflineRibbonDelegate: class {
    func offlineRibbonWillDisappear()
    func offlineRibbonWillAppear()
}

class VFGOfflineRibbonView: UIView {

    enum ShakeAnimation {
        static let offset: CGFloat = 4.0
        static let duration: Double = 0.08
        static let repeatCount: Float = 3
        static let keyPath = "position"
    }

    fileprivate(set) lazy var animationView: AnimationView = {
        return AnimationView()
    }()

    var heightConstraint: NSLayoutConstraint
    var refreshIcon: UIImageView
    var offlineMessage: UILabel
    var lastUpdateMessage: UILabel
    var failureMessageText: String = "Error Occurred" {
        didSet {
            offlineMessage.text = failureMessageText
        }
    }
    weak var delegate: VFGOfflineRibbonDelegate?
    var offlineCurrentlyShown: Bool = false
    var isErrorRibbonCurrentlyShown: Bool = false

    required init() {
        heightConstraint = NSLayoutConstraint()
        refreshIcon = UIImageView(image: UIImage(named: RefreshArrow.imageName,
                                                 in: Bundle(for: type(of: self))))
        offlineMessage = UILabel(frame: NetworkStatus.rect)
        lastUpdateMessage = UILabel(frame: LastUpdate.rect)
        super.init(frame: View.rect)
        clipsToBounds = true
        alpha = View.invisibleAlpha

        backgroundColor = UIColor.VFGBlack

        animationView = AnimationView(frame: ErrorIcon.rect)
        animationView.backgroundColor = UIColor(patternImage: UIImage(named: ErrorIcon.imageName,
                                                                      in: Bundle(for: type(of: self)))!)
        animationView.contentMode = UIView.ContentMode.scaleAspectFill

        refreshIcon.contentMode = UIView.ContentMode.scaleAspectFit
        refreshIcon.frame = RefreshArrow.rect

        offlineMessage.text = NetworkStatus.offlineText
        offlineMessage.textAlignment = NSTextAlignment.left
        offlineMessage.font = UIFont.VFGM()
        offlineMessage.textColor = UIColor.VFGWhite
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let parent = superview, let grandparent = superview?.superview
            else { return }
        autoPinEdge(.bottom, to: .top, of: parent)
        heightConstraint = autoSetDimension(.height, toSize: View.rect.origin.y)
        heightConstraint.priority = UILayoutPriority(rawValue: 1000)
        autoPinEdge(.trailing, to: .trailing, of: grandparent, withOffset: ShakeAnimation.offset)
        autoPinEdge(.leading, to: .leading, of: grandparent, withOffset: -ShakeAnimation.offset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not implemented.")
    }

    // Added failureMessage to enable showing an error message for 3 seconds
    @objc open func showOfflineRibbon(withMessage message: String, failureMessage: String? = nil) {
        VFGRootViewController.shared.isOfflineRibbonVisible = true
        animationView.transform = CGAffineTransform.identity
        refreshIcon.alpha = View.visibleAlpha
        //If there's failure message, show the error
        if let failureMsg = failureMessage {
            offlineCurrentlyShown = false
            isErrorRibbonCurrentlyShown = true
            offlineMessage.text = failureMsg
            offlineMessage.sizeToFit()
        } else {
            offlineCurrentlyShown = true
            lastUpdateMessage.alpha = View.visibleAlpha
            lastUpdateMessage.attributedText = NSAttributedString.buildRefreshTimeStamp(usingTimeStamp: message)
            offlineMessage.text = NetworkStatus.offlineText
        }
        stopLottieAnimation()
    }
    private func stopLottieAnimation() {
        animationView.animation = Animation.named("")
        animationView.backgroundColor = UIColor(patternImage: UIImage(named: ErrorIcon.imageName,
                                                                      in: Bundle(for: type(of: self)))!)
        heightConstraint.constant = View.rect.height
        manageRibbon(usingAlpha: View.visibleAlpha)
    }

    @objc open func showOnlineRibbon() {
        if offlineCurrentlyShown {
            lastUpdateMessage.alpha = View.invisibleAlpha
            refreshIcon.alpha = View.invisibleAlpha
            animationView.backgroundColor = UIColor.clear
            offlineMessage.text = NetworkStatus.onlineText

            animationView.animation = AnimationEnum.composition(for: .successTickOffline)!
            animationView.transform = CGAffineTransform(scaleX: AnimationEnum.scaleXtransformation,
                                                        y: AnimationEnum.scaleYtransformation)

            animationView.loopMode = .playOnce
            animationView.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + View.hideRibbonDelay, execute: { [weak self] in
                guard let `self` = self else { return }
                self.manageRibbon(usingAlpha: View.invisibleAlpha)
                self.offlineCurrentlyShown = false
            })
        } else if isErrorRibbonCurrentlyShown {
            animationView.backgroundColor = UIColor.clear
            refreshIcon.alpha = View.visibleAlpha
            alpha = View.invisibleAlpha
            delegate?.offlineRibbonWillDisappear()
            isErrorRibbonCurrentlyShown = false
        }
    }

    private func manageRibbon(usingAlpha viewAlpha: CGFloat) {
        UIView.animate(withDuration: View.showRibbonAnimationDuration,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.alpha = viewAlpha
                        self.layoutIfNeeded()
            },
                       completion: { _ in
                        if viewAlpha == View.visibleAlpha {
                            self.delegate?.offlineRibbonWillAppear()
                        } else {
                            self.delegate?.offlineRibbonWillDisappear()
                        }
        })
    }

    func setErrorIcon() {
        addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: animationView,
                                         attribute: .leading,
                                         toItem: self,
                                         attribute: .leading,
                                         constant: CGFloat(ErrorIcon.leadingDistance)))

        addConstraint(NSLayoutConstraint(item: animationView,
                                         attribute: .top,
                                         toItem: self,
                                         attribute: .top,
                                         constant: CGFloat(ErrorIcon.topDistance)))

        addConstraint(NSLayoutConstraint(item: animationView,
                                         attribute: .width,
                                         toItem: nil,
                                         attribute: .width,
                                         constant: ErrorIcon.rect.width))

        addConstraint(NSLayoutConstraint(item: animationView,
                                         attribute: .height,
                                         toItem: nil,
                                         attribute: .height,
                                         constant: ErrorIcon.rect.height))
    }

    func setRefreshIcon() {
        addSubview(refreshIcon)

        refreshIcon.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshIcon,
                                         attribute: .trailing,
                                         toItem: self,
                                         attribute: .trailing,
                                         constant: -CGFloat(RefreshArrow.trailingDistance)))

        addConstraint(NSLayoutConstraint(item: refreshIcon,
                                         attribute: .top,
                                         toItem: self,
                                         attribute: .top,
                                         constant: CGFloat(RefreshArrow.topDistance)))

        addConstraint(NSLayoutConstraint(item: refreshIcon,
                                         attribute: .width,
                                         toItem: nil,
                                         attribute: .width,
                                         constant: RefreshArrow.rect.width))

        addConstraint(NSLayoutConstraint(item: refreshIcon,
                                         attribute: .height,
                                         toItem: nil,
                                         attribute: .height,
                                         constant: RefreshArrow.rect.height))
    }

    func setOfflineMessage() {
        addSubview(offlineMessage)

        offlineMessage.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: offlineMessage,
                                         attribute: .leading,
                                         toItem: animationView,
                                         attribute: .trailing,
                                         constant: CGFloat(NetworkStatus.trailingDistance)))

        addConstraint(NSLayoutConstraint(item: offlineMessage,
                                         attribute: .top,
                                         toItem: self,
                                         attribute: .top,
                                         constant: CGFloat(NetworkStatus.topDistance)))
    }

    func setLastUpdateMessage() {
        addSubview(lastUpdateMessage)
        lastUpdateMessage.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshIcon,
                                         attribute: .leading,
                                         toItem: lastUpdateMessage,
                                         attribute: .trailing,
                                         constant: CGFloat(LastUpdate.trailingDistance)))

        addConstraint(NSLayoutConstraint(item: lastUpdateMessage,
                                         attribute: .top,
                                         toItem: self,
                                         attribute: .top,
                                         constant: CGFloat(LastUpdate.topDistance)))
    }

    internal func shake() {
        let animation = CABasicAnimation(keyPath: ShakeAnimation.keyPath)
        animation.duration = ShakeAnimation.duration
        animation.repeatCount = ShakeAnimation.repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - ShakeAnimation.offset, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + ShakeAnimation.offset, y: center.y))
        layer.add(animation, forKey: ShakeAnimation.keyPath)
    }
}

// MARK: - Helpers
extension VFGOfflineRibbonView {
    var isVisible: Bool {
        return isErrorRibbonCurrentlyShown || offlineCurrentlyShown
    }
}

extension NSAttributedString {
    class func buildRefreshTimeStamp(usingTimeStamp timeStamp: String) -> NSAttributedString {
        let lastUpdated = "Last updated: "
        let message: String =  lastUpdated + timeStamp
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: message)
        let fontRange: NSRange = (message as NSString)
            .range(of: message)
        let prefixMessageRange: NSRange = (message as NSString)
            .range(of: lastUpdated)
        let suffixMessageRange: NSRange = (message as NSString)
            .range(of: timeStamp)
        let fontAttribute = [NSAttributedString.Key.font: UIFont.VFGS() ?? UIFont.systemFont(ofSize: 16.0)]
        let prefixColorAttributes = [NSAttributedString.Key.foregroundColor: UIColor.VFGGreyish]
        let suffixColorAttributes = [NSAttributedString.Key.foregroundColor: UIColor.VFGWhite]
        attributedString.addAttributes(fontAttribute,
                                       range: fontRange)
        attributedString.addAttributes(prefixColorAttributes,
                                       range: prefixMessageRange)
        attributedString.addAttributes(suffixColorAttributes,
                                       range: suffixMessageRange)
        return attributedString
    }
}
