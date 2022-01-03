//
//  VFGSpinnerView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class VFGSpinnerView: UIView, CAAnimationDelegate {

    private struct Const {
        static let start: CGFloat = -Angle.halfPi
        static let end: CGFloat = Angle.oneAndHalfPi
    }

    var lineWidth: CGFloat = 4.0 {
        didSet {
            animatingCircle.lineWidth = lineWidth
            containAnimatingCircle()
        }
    }

    // MARK: UIView
    override init(frame: CGRect) {
        func setupAnimatingCircle(_ frame: CGRect) {
            animatingCircle.frame = bounds

            // Account for animating circle line width
            containAnimatingCircle()
            setAnimatingCirclePathAndAnimations()
        }

        super.init(frame: frame)
        layer.addSublayer(animatingCircle)
        setupAnimatingCircle(frame)
        stopAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("VFGSpinnerView does not support being loaded from nibs or storyboards")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        animatingCircle.frame = bounds
        containAnimatingCircle()
        setAnimatingCirclePathAndAnimations()
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        animatingCircle.strokeColor = tintColor.cgColor
    }

    // MARK: public functions
    func startAnimating() {
        stopAnimating()
        animatingCircle.resumeAllAnimations()
    }

    func stopAnimating() {
        animatingCircle.removeAllAnimations()
        animatingCircle.add(animations, forKey: "animations")
        animatingCircle.pauseAllAnimations()
    }

    // MARK: Private functions
    fileprivate func containAnimatingCircle() {
        animatingCircle.bounds = bounds
    }

    fileprivate func setAnimatingCirclePathAndAnimations() {
        let circleCenter: CGFloat = animatingCircle.bounds.width / 2
        let centerPoint = CGPoint(x: circleCenter, y: circleCenter)
        let circleRadius: CGFloat = circleCenter * 0.83
        let newPath = UIBezierPath(arcCenter: centerPoint,
                                   radius: circleRadius,
                                   startAngle: Const.start,
                                   endAngle: Const.end,
                                   clockwise: true).cgPath

        animatingCircle.path = newPath
        animatingCircle.add(animations, forKey: "animations")
    }

    // MARK: Lazy properties
    fileprivate lazy var strokeEndAnimation: CABasicAnimation = {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = CAMediaTimingFillMode.forwards
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEndAnimation.duration = 0.9
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        return strokeEndAnimation
    }()

    fileprivate lazy var strokeBeginAnimation: CABasicAnimation = {
        let strokeBeginAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeBeginAnimation.isRemovedOnCompletion = false
        strokeBeginAnimation.fillMode = CAMediaTimingFillMode.forwards
        strokeBeginAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeBeginAnimation.duration = 0.9
        strokeBeginAnimation.fromValue = 0
        strokeBeginAnimation.toValue = 1
        strokeBeginAnimation.beginTime = 0.9
        return strokeBeginAnimation
    }()

    fileprivate lazy var strokeWrapAroundAnimations: CAAnimationGroup = {
        let strokeWrapAroundAnimations = CAAnimationGroup()
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.isRemovedOnCompletion = false
        endAnimation.fillMode = CAMediaTimingFillMode.forwards
        endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        endAnimation.duration = 0.85
        endAnimation.fromValue = 1
        endAnimation.toValue = 0.0
        endAnimation.beginTime = 1.95

        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.isRemovedOnCompletion = false
        startAnimation.fillMode = CAMediaTimingFillMode.forwards
        startAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        startAnimation.duration = 0.8
        startAnimation.fromValue = 1
        startAnimation.toValue = 0.0
        startAnimation.beginTime = 1.9
        strokeWrapAroundAnimations.animations = [startAnimation, endAnimation]
        return strokeWrapAroundAnimations
    }()

    fileprivate lazy var animations: CAAnimationGroup = {
        let animations = CAAnimationGroup()
        animations.fillMode = CAMediaTimingFillMode.forwards
        animations.isRemovedOnCompletion = false
        animations.repeatCount = Float.infinity
        animations.duration = 2.75
        animations.animations = [strokeEndAnimation, strokeBeginAnimation, strokeWrapAroundAnimations]
        animations.delegate = self
        return animations
    }()

    fileprivate lazy var animatingCircle: CAShapeLayer = {
        let outlineCircle = CAShapeLayer()
        outlineCircle.strokeColor = self.tintColor.cgColor
        outlineCircle.lineWidth = 4.0
        outlineCircle.lineCap = CAShapeLayerLineCap.round
        outlineCircle.fillColor = UIColor.clear.cgColor
        return outlineCircle
    }()

}
