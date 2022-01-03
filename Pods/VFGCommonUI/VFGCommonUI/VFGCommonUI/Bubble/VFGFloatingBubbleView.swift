//
//  VFGFloatingBubbleButton.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 3/16/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
import VFGCommonUtils

internal struct AnimationsConst {
    static let bubbleAnimationScaleFactor: Double = 1.2
    static let bubbleAnimationScaleDuration: Double = 0.13
    static let bubbleExpandDuration: Double = 0.67
    static let bubbleChangePhotoAnimationDuration: Double = 1.2
    static let bubbleChangePhotoEndingAnimationDuration: Double = 0.5
    static let bubbleEnvelopeAnimationDuration: Double = 1.0
    static let bubbleChangePositionAnimationDuration: Double = 0.5
    static let bubbbeScaleOutAnimationDuration: Double = 1.0
}

internal struct BubbleColors {
    static let text: UIColor = UIColor(red: 230.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let textSecondary: UIColor = UIColor.white
}

@objc public class VFGFloatingBubbleView: UIView, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    internal var lottiAnimationView: AnimationView!
    private var player: AVAudioPlayer?
    private let transition = VFGBubbleTransition()
    @objc public var presentedViewController: UIViewController?
    internal weak var superView: UIView?
    private var viewTitle: String = "commonui_needhelp_bubble_text".localized
    private let lineSpacing: CGFloat = 3.0
    private let viewTopFont: UIFont? = UIFont.vodafoneRegularFont(16.0)

    private var viewImage: UIImage? = UIImage(named: "bubble", in: Bundle.vfgCommonUI)
    private var viewSecondaryImage: UIImage? = UIImage(named: "redBubble", in: Bundle.vfgCommonUI)
    internal var envelopeImageViewContainer: UIView = UIView(frame: CGRect(x: 3, y: 3, width: 23, height: 23))

    internal var textLabel: UILabel = UILabel()
    internal var imageView: UIImageView = UIImageView()
    internal var secondImageView: UIImageView = UIImageView()
    private var envelopeImageView: UIImageView = UIImageView(image: UIImage(named: "notification_Envlope_white",
                                                                            in: Bundle.vfgCommonUI))
    private var envelopeImage: UIImage!
    private let audioSession = AVAudioSession.sharedInstance()
    private let statusBarHeight: CGFloat = 21.0
    private let topBarHeight: CGFloat = 44.0
    private let nudgeMaxHeight: CGFloat = 240.0
    private var yPosition: CGFloat

    // MARK: - Animation Properties
    @objc internal var isSecondLevel: Bool = false {
        didSet {
            if isSecondLevel {
                setSecondLevelConfig()
            } else {
                setFirstLevelConfig()
            }
        }
    }

    // this boolean responsible for switching the imageView for bubble icon, if it is true,
    // a function will be called to theme the imageview with the right notification bubble icon.
    internal var hasNewNotification: Bool = false {
        didSet {
            animateEnvelopeImageViewContainerIfInNotificationMode()
        }
    }

    // MARK: UIViewControllerTransitioningDelegate
    @objc public func animationController(forPresented presented: UIViewController,
                                          presenting: UIViewController,
                                          source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.frame.midX-5, y: self.frame.midY-25) //self.center
        return transition
    }

    @objc public func animationController(forDismissed dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.frame.midX-5, y: self.frame.midY-25) //self.center
        return transition
    }

    @objc public var clickAction: (() -> Void)?

    // MARK: - Init
    required public init(withView view: UIView,
                         bubbleImage: UIImage? = nil,
                         bubbleSecondaryImage: UIImage? = nil) {
        viewImage = (bubbleImage != nil) ? bubbleImage : viewImage
        viewSecondaryImage = (bubbleSecondaryImage != nil) ? bubbleSecondaryImage : viewSecondaryImage
        imageView = UIImageView(image: viewImage)
        imageView.sizeToFit()

        yPosition = view.bounds.size.height - (view.bounds.size.height * 0.28)
        super.init(frame: CGRect(x: view.bounds.size.width - imageView.bounds.size.width - 5.0,
                                 y: yPosition,
                                 width: imageView.bounds.size.width,
                                 height: imageView.bounds.size.height))

        addSubview(imageView)
        superView = view
        addLabel()
        addNotificationIcon()
        view.addSubview(self)
        createPanGesture()
        addTapGestureAction()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public Utils
    @objc public func setBubbleTitle(title: String) {
        viewTitle = title
        addLabel()
    }

    @objc internal func setSecondLevel(_ isSecondLevel: Bool) {
        self.isSecondLevel = isSecondLevel
    }

    //setter and getter methods for HasNewNotification variable.
    @objc public func setHasNewNotification(_ hasNotification: Bool) {
        hasNewNotification = hasNotification
    }

    @objc public func isFloatingBubbleInNotificationState() -> Bool {
        return hasNewNotification
    }

    // MARK: - Actions
    func addTapGestureAction() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
    }

    @objc func tapGestureAction() {
        superView?.endEditing(true)
        VFGAnalyticsHandler.trackEventForFloatingBubbleClick()
        clickAction?()
        guard let presentedViewController: UIViewController = presentedViewController else {
            VFGErrorLog("Cannot unwrap presentedViewController")
            return
        }
        startBubbleAnimations(presentedViewController: presentedViewController)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }

    // MARK: - Subviews
    internal func addLabel() {
        textLabel.numberOfLines = 0
        if isSecondLevel {
            textLabel.attributedText = getLabelFormattedStringForColor(BubbleColors.textSecondary)
        } else {
            textLabel.attributedText = getLabelFormattedStringForColor(BubbleColors.text)
        }
        textLabel.frame = bounds
        textLabel.sizeToFit()
        textLabel.textAlignment = .center
        textLabel.center = CGPoint(x: bounds.center.x, y: bounds.center.y - 5)
        addSubview(textLabel)
    }

    private func addNotificationIcon() {
        envelopeImageViewContainer.layer.cornerRadius = envelopeImageViewContainer.frame.size.width / 2
        envelopeImageViewContainer.clipsToBounds = true
        envelopeImageViewContainer.layer.borderWidth = 1

        let containerWidth = envelopeImageViewContainer.frame.size.width
        let containerHeight = envelopeImageViewContainer.frame.size.height
        envelopeImageView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: containerWidth - 5,
                                         height: containerHeight - 5)
        envelopeImageViewContainer.addSubview(envelopeImageView)
        envelopeImageView.frame = CGRect(x: containerWidth/2 - (envelopeImageView.frame.size.width/2),
                                         y: containerHeight/2 - (envelopeImageView.frame.size.height/2),
                                         width: envelopeImageView.frame.size.width,
                                         height: envelopeImageView.frame.size.height)
        addSubview(envelopeImageViewContainer)

        if !hasNewNotification {
            envelopeImageViewContainer.alpha = 0
        }
        envelopeImageViewContainer.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: containerWidth,
                                                  height: containerHeight)
    }

    // MARK: - Private Utils
    /* Changing UI colors for first and second levels configuration */
    private func setFirstLevelConfig() {
        VFGDebugLog("Setting first level config for VFGFloatingBubbleView")
        secondImageView.removeFromSuperview()
        textLabel.attributedText = getLabelFormattedStringForColor(BubbleColors.text)
        updateViewWithImage(viewImage)
        envelopeImage = UIImage(named: "notification_Envlope_white", in: Bundle.vfgCommonUI)
        envelopeImageViewContainer.backgroundColor = BubbleColors.text
        envelopeImageViewContainer.layer.borderColor = BubbleColors.textSecondary.cgColor
        envelopeImageView.image = envelopeImage
    }

    private func setSecondLevelConfig() {
        VFGDebugLog("Setting second level config for VFGFloatingBubbleView")
        secondImageView.removeFromSuperview()
        textLabel.attributedText = getLabelFormattedStringForColor(BubbleColors.textSecondary)
        updateViewWithImage(viewSecondaryImage)
        envelopeImage = UIImage(named: "notification_Envlope_red", in: Bundle.vfgCommonUI)
        envelopeImageViewContainer.backgroundColor = BubbleColors.textSecondary
        envelopeImageViewContainer.layer.borderColor = BubbleColors.text.cgColor
        envelopeImageView.image = envelopeImage
    }

    private func updateViewWithImage(_ image: UIImage?) {
        imageView.image = image
        imageView.sizeToFit()
    }

    internal func getLabelFormattedStringForColor(_ color: UIColor) -> NSMutableAttributedString? {
        guard let viewTopFont: UIFont = viewTopFont else {
            VFGErrorLog("Cannot unwrap viewTopFont")
            return nil
        }
        let titleStr = NSAttributedString(string: viewTitle,
                                          attributes: [NSAttributedString.Key.font: viewTopFont,
                                                       NSAttributedString.Key.foregroundColor: color])
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = 15
        paragraphStyle.alignment = .center
        let attrString: NSMutableAttributedString = NSMutableAttributedString()

        attrString.append(titleStr)
        attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: attrString.length))
        return attrString
    }

    // MARK: - Action Methods
    //Adding Pan Gesture Recoginzer to Button
    private func createPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc public func getExpectedAnimationDuration() -> Double {
        var result = AnimationsConst.bubbleExpandDuration +
            AnimationsConst.bubbleChangePhotoAnimationDuration +
            AnimationsConst.bubbbeScaleOutAnimationDuration
        if hasNewNotification {
            result += AnimationsConst.bubbleEnvelopeAnimationDuration
        }
        return result
    }

    //Handling button dragging over the screen
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let superView: UIView = superView,
            let recognizerView: UIView = recognizer.view else {
            VFGErrorLog("Cannot unwrap views. Terminating handlePan()")
            return
        }

        superView.endEditing(true)
        VFGDebugLog("recognizer state:\(recognizer.state.rawValue)")

        if recognizer.state == .began {
            superView.isUserInteractionEnabled = false
        } else if recognizer.state == .ended {
            superView.isUserInteractionEnabled = true
        }
        let translation: CGPoint = recognizer.translation(in: superView)
        let doubleStatusBarHeight = statusBarHeight * 2
        var yToBe: CGFloat = recognizerView.frame.origin.y + translation.y

        let nudgeTop = max(VFGRootViewController.shared.nudgeViewHeightConstraint.constant - doubleStatusBarHeight, 0)
        let minYPosition = doubleStatusBarHeight + topBarHeight + nudgeTop
        let maxYPosition = superView.bounds.size.height - recognizerView.frame.size.height - topBarHeight
        if yToBe < minYPosition {
            yToBe = minYPosition
        } else if yToBe > maxYPosition {
            yToBe = maxYPosition
        }
        VFGDebugLog("yToBe:\(yToBe)")
        recognizer.view?.frame.origin = CGPoint(x: recognizerView.frame.origin.x, y: yToBe)
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
}

extension VFGFloatingBubbleView {
    internal func playSound() {
        let popSound: String = "pop"
        let popSoundExt: String = "mp3"
        guard let url: URL = Bundle.vfgCommonUI.url(forResource: popSound, withExtension: popSoundExt) else {
            VFGErrorLog("Cannot find sound file:\(popSound).\(popSoundExt)")
            return
        }
        do {
            if #available(iOS 10.0, *) {
                try audioSession.setCategory(.ambient, mode: .default, options: .mixWithOthers)
            } else {
                // Bug in swift 4.2
                // https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949
            }

            try audioSession.setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.delegate = self
            player.prepareToPlay()
            player.play()
        } catch let error {
            VFGErrorLog(error.localizedDescription)
        }
    }
    //Handling bubble postion when show/hide nudge view
    @objc internal func updateBubblePosition(isNudgeVisible: Bool) {
        guard let superView = superView else {
            return
        }
        let currentNudgeHeight = VFGRootViewController.shared.nudgeViewHeightConstraint.constant
        let minYPosition: CGFloat = 2*statusBarHeight + topBarHeight + currentNudgeHeight
        let maxYpostion: CGFloat = superView.bounds.size.height - frame.size.height - topBarHeight
        let delta: CGFloat = isNudgeVisible ? nudgeMaxHeight : -nudgeMaxHeight
        let yToBe = frame.origin.y + delta
        let minY = max(yToBe, minYPosition)
        let maxY = min(minY, maxYpostion)
        if !isNudgeVisible && yToBe - delta == maxYpostion {
            frame.origin = CGPoint(x: frame.origin.x, y: yPosition)
        } else {
            frame.origin = CGPoint(x: frame.origin.x, y: maxY)
        }
    }
}

extension VFGFloatingBubbleView: AVAudioPlayerDelegate {
    private func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            try audioSession.setActive(false)
        } catch let error {
            VFGErrorLog(error.localizedDescription)
        }
    }
}
