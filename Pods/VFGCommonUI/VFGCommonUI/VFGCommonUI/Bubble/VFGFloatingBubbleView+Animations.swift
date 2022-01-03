//
//  VFGFloatingBubbleView+Animations.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Lottie
import VFGCommonUtils

extension VFGFloatingBubbleView {

    private var bubbleWithoutRoute: UIImage? {
        return UIImage(named: "whitBubbleWithoutRoute", in: Bundle.vfgCommonUI)
    }
    private var redbubbleWithoutRoute: UIImage? {
        return UIImage(named: "speechBubbleWithoutRoot", in: Bundle.vfgCommonUI)
    }

    @objc private func scaleInAnimation() {
        envelopeImageViewContainer.alpha = 0
        transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        let secondImageName = isSecondLevel ? redbubbleWithoutRoute : bubbleWithoutRoute
        secondImageView = UIImageView(image: secondImageName)
        addSubview(secondImageView)
        textLabel.alpha = 0
        imageView.alpha = 0
        secondImageView.alpha = 1
    }

    @objc private func scaleOutAnimation() {
        UIView.animate(withDuration: AnimationsConst.bubbbeScaleOutAnimationDuration) { [weak self] in
            guard let `self` = self else { return }
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.textLabel.alpha = 1
            self.textLabel.attributedText = self.getLabelFormattedStringForColor(BubbleColors.textSecondary)
            self.addLabel()
        }
    }

    @objc private func changePhotoAnimation() {
        UIView.animate(withDuration: AnimationsConst.bubbleChangePhotoAnimationDuration,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.imageView.alpha = 1
            },
                       completion: { [weak self] completed in
                        guard let `self` = self, completed else { return }
                        UIView.animate(withDuration: AnimationsConst.bubbleChangePhotoEndingAnimationDuration,
                                       animations: { [weak self] in
                                        guard let `self` = self else { return }
                                        self.secondImageView.alpha = 0
                            },
                                       completion: { (completed) in
                                        if completed {
                                            self.animateEnvelopeImageViewContainerIfInNotificationMode()
                                        }
                        })
        })
    }

    @objc public func scaleWhiteBubble() {
        secondImageView.removeFromSuperview()
        perform(#selector(self.scaleInAnimation), with: self, afterDelay: 0)
        perform(#selector(self.scaleOutAnimation),
                with: self,
                afterDelay: AnimationsConst.bubbleExpandDuration)
        perform(#selector(self.changePhotoAnimation),
                with: self,
                afterDelay: AnimationsConst.bubbleChangePhotoAnimationDuration)
    }

    @objc public func playExpandAnimation() {
        guard let controller: UIViewController = presentedViewController else {
            VFGErrorLog("Cannot unwrap presentedViewController")
            return
        }
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        isHidden = true
        VFGRootViewController.shared.sideMenu.hideMenu()
        getTopViewController()?.present(controller, animated: true, completion: {
            self.lottiAnimationView.removeFromSuperview()
        })
        getTopViewController()?.transitioningDelegate = self
        getTopViewController()?.modalPresentationStyle = .custom
    }

    @objc public func startBubbleAnimations(presentedViewController: UIViewController) {
        UIView.animate(withDuration: AnimationsConst.bubbleAnimationScaleDuration,
                       delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.transform = CGAffineTransform(scaleX: CGFloat(AnimationsConst.bubbleAnimationScaleFactor),
                                                           y: CGFloat(AnimationsConst.bubbleAnimationScaleFactor))
            }, completion: { (_) in
                self.isHidden = true
        })
        perform(#selector(self.playExplotionAnimation), with: self, afterDelay: 0 )
    }

    @objc public func startBubbleAnimationsWithDelay(presentedViewController: UIViewController) {
        UIView.animate(withDuration: AnimationsConst.bubbleAnimationScaleDuration,
                       delay: 0.6, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                        self?.transform = CGAffineTransform(scaleX: CGFloat(AnimationsConst.bubbleAnimationScaleFactor),
                                                            y: CGFloat(AnimationsConst.bubbleAnimationScaleFactor))
            }, completion: { (_) in
                self.isHidden = true
        })
        perform(#selector(self.playExplotionAnimation), with: self, afterDelay: 0 )
    }

    @objc public func playExplotionAnimation() {
        let animationResourceName: String = "bubblepop_isolated"
        lottiAnimationView = AnimationView(name: animationResourceName, bundle: Bundle.vfgCommonUI)
        lottiAnimationView.frame = self.frame
        playSound()
        superView?.addSubview(lottiAnimationView)
        lottiAnimationView.play()
        perform(#selector(self.playExpandAnimation), with: self,
                afterDelay: AnimationsConst.bubbleAnimationScaleDuration )
    }

    @objc internal func animateEnvelopeImageViewContainerIfInNotificationMode() {
        let param: CGFloat = hasNewNotification ? 1 : 0
        UIView.animate(withDuration: AnimationsConst.bubbleEnvelopeAnimationDuration) {
            self.envelopeImageViewContainer.transform = CGAffineTransform(scaleX: param, y: param)
            self.envelopeImageViewContainer.alpha = param
        }

        UIView.animate(withDuration: AnimationsConst.bubbleChangePositionAnimationDuration, animations: {
            self.addLabel()
        })
    }

}
