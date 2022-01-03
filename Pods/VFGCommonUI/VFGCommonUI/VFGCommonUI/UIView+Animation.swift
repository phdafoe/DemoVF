//
//  UIView+Animation.swift
//  VFGCommonUI
//
//  Created by Manar Magdy on 4/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public struct CycleAnimationConfiguration {
    var oldVC: UIViewController
    var newVC: UIViewController
    var containerView: UIView
    var isForward: Bool
    var animationDuration: TimeInterval
    var completionHandler: (() -> Void)?

    public init(oldVC: UIViewController,
                newVC: UIViewController,
                containerView: UIView,
                isForward: Bool,
                animationDuration: TimeInterval,
                completionHandler: (() -> Void)?) {
        self.oldVC = oldVC
        self.newVC = newVC
        self.containerView = containerView
        self.isForward = isForward
        self.animationDuration = animationDuration
        self.completionHandler = completionHandler
    }
}

public extension UIView {

    /**
     This method provides horizontal animation from the current point "predefined" to the target point.
     
     - parameter targetView: the view that will be moved with animation
     - parameter to: the view the destination point
     - parameter animationDuration: the animation duration
     
     */
    @objc static func animateHorizontally(targetView: UIView,
                                          to destinationPoint: CGFloat,
                                          animationDuration: TimeInterval) {

        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: 0,
                                options: .calculationModeLinear,
                                animations: {
                                    var frame: CGRect = targetView.frame
                                    frame.origin.x = destinationPoint
                                    targetView.frame = frame
        },
                                completion: nil)
    }
    static func cycleAnimation(with configuration: CycleAnimationConfiguration) {
        let containerWidth = configuration.containerView.frame.width
        let offScreenRight = CGAffineTransform(translationX: -containerWidth * (configuration.isForward ? -1 : 1), y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -containerWidth * (configuration.isForward ? 1 : -1), y: 0)
        configuration.newVC.view.transform = offScreenRight

        //        containerView.frame = newVC.view.bounds
        configuration.containerView.addSubview(configuration.newVC.view)
        configuration.newVC.view.superview?.isUserInteractionEnabled = false

        UIView.animate(withDuration: configuration.animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.5,
                       initialSpringVelocity: 1.8,
                       options: UIView.AnimationOptions(rawValue: 0),
                       animations: {
                        configuration.oldVC.view.transform = offScreenLeft
                        configuration.newVC.view.transform = CGAffineTransform.identity

        }, completion: { (_) in
            configuration.completionHandler?()
            configuration.oldVC.view.removeFromSuperview()
            configuration.newVC.view.superview?.isUserInteractionEnabled = true
        })
    }

    /**
     This method adds shadow effect to a specific view.
     
     - parameter view: the targeted view that we want to add shadow to
     - parameter shadowColor: the shadow color
     - parameter shadowOpacity: the shadow opacity
     - parameter shadowRadius: the shadow radius
     
     */
    @objc static func addShadowEffect(view: UIView, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
    }

    /**
     This method provides Scale Animation to a specific view.
     
     - targetView view: the targeted view that we want to add shadow to
     - parameter animationDuration: the animaiton Duration
     - parameter scaleFactor: the animaiton Scale Factor
     - parameter animationDelay: Delay of the animation
     
     */
    @objc static func scaleAnimation(targetView: UIView,
                                     animationDuration: TimeInterval,
                                     scaleFactor: Double,
                                     animationDelay: Double) {

        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: animationDelay,
                                options: .calculationModeLinear,
                                animations: {
                                    targetView.transform = CGAffineTransform(scaleX: CGFloat(scaleFactor),
                                                                             y: CGFloat(scaleFactor))
        },
                                completion: nil)
    }

    /**
     This method provides fading animation for a specific view
     - parameter animationDuration: the needed time to finish this animation
     - parameter opacity: the faded view opacity
     - parameter targetView: the view that we will apply the fading animation on
     */
    @objc static func fadeView(animationDuration: TimeInterval, opacity: CGFloat, targetView: UIView) {
        UIView.animate(withDuration: animationDuration, animations: {
            targetView.alpha = opacity
        })
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

}
