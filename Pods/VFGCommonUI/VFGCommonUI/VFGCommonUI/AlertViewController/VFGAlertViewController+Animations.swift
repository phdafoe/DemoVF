//
//  VFGAlertViewController+Animations.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import RBBAnimation

extension VFGAlertViewController {

    private struct Const {
        static let buttonsAnimationOffset: CGFloat = 500
        static let buttonsDismissAnimationOffset: CGFloat = (UIScreen.main.bounds.size.height / 568.0) * 550
        static let contentSlideAnimationTime: TimeInterval = 0.50
    }

    func slideAnimation(upwards: Bool, for animatedView: UIView) -> RBBTweenAnimation {
        let animation: RBBTweenAnimation = RBBTweenAnimation(keyPath: "position.y")

        let verticalCenter = animatedView.frame.center.y
        if upwards {
            animation.fromValue = NSNumber(value: Float(verticalCenter + Const.buttonsAnimationOffset))
            animation.toValue = NSNumber(value: Float(verticalCenter))
        } else {
            animation.fromValue = NSNumber(value: Float(verticalCenter))
            animation.toValue = NSNumber(value: Float(verticalCenter + Const.buttonsDismissAnimationOffset))
        }

        animation.easing = VFGCommonUIAnimations.RBBEasingFunctionEaseOutExpo
        animation.duration = Const.contentSlideAnimationTime

        return animation
    }

    func alphaAnimation(toVisible: Bool) -> RBBTweenAnimation {

        let animation: RBBTweenAnimation = RBBTweenAnimation(keyPath: "opacity")

        if toVisible {
            animation.fromValue = NSNumber(value: 0)
            animation.toValue = NSNumber(value: 1)
        } else {
            animation.fromValue = NSNumber(value: 1)
            animation.toValue = NSNumber(value: 0)
        }

        animation.easing = VFGCommonUIAnimations.RBBEasingFunctionEaseOutExpo
        animation.duration = Const.contentSlideAnimationTime

        return animation
    }

}
