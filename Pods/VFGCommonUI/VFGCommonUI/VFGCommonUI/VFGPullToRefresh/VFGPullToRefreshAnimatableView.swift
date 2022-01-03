//
//  VFGPullToRefreshAnimatableView.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/*
 *  A RefreshControl has a height of 60pts, the rest is taken from design specifications
 */
private enum Constants {
    enum RefreshControlView {
        static let width = UIScreen.main.bounds.width
        static let height = 60
    }

    enum Container {
        static let width = 29
        static let height = 37
    }

    enum ExpandableCircle {
        static let width = 29
        static let height = 30
        static let duration = 0.5
        static let scaleXTransformation: CGFloat = 20.0
        static let scaleYTransformation: CGFloat = 20.0
        static let returnCallbackTimer = 1.0
    }

    enum LoadingView {
        static let width = 100
        static let height = 48
    }

}

internal protocol VFGPullToRefreshAnimatableViewProtocol {
    func setInitialAnimationState()
    func performDraggingUpdates(with progress: CGFloat)
    func performLoadingAnimation()
    func performFinishedAnimation(_ completion: @escaping (Bool) -> Void)
}

internal class VFGPullToRefreshAnimatableView: UIView {
    enum AnimationEnum: String {
        case dragging = "pull_vf_speechmark_p1"
        case loading = "pull_vf_speechmark_p2"
        case loading2 = "pull_vf_speechmark_p3_loop"
        case successTickOffline = "offline_success_tick_green"
        case successTickOnline = "pull_success_tick_white"

        static func composition(for animation: AnimationEnum) -> Animation? {
            return Animation.named(animation.rawValue, bundle: Bundle.vfgCommonUI)
        }
    }

    fileprivate(set) lazy var animationView: AnimationView = {
        return AnimationView()
    }()

    var animationContainer: UIView
    var expandableCircle: UIView
    var refreshControlBgColor: UIColor
    var expandableCircleBgColor: UIColor

    required init() {
        animationContainer = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: Constants.Container.width,
                                                  height: Constants.Container.height))
        expandableCircle = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: Constants.ExpandableCircle.width,
                                                height: Constants.ExpandableCircle.height))

        refreshControlBgColor = UIColor.VFGRefreshableViewColor
        expandableCircleBgColor = UIColor.VFGExpandableCircleColor

        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: Int(Constants.RefreshControlView.width),
                                 height: Constants.RefreshControlView.height))
        tintColor = UIColor.clear
        backgroundColor = refreshControlBgColor
        clipsToBounds = true

        animationContainer.center = center
        animationContainer.backgroundColor = UIColor.clear

        animationView.frame = CGRect(x: 0, y: 0,
                                     width: Constants.LoadingView.width,
                                     height: Constants.LoadingView.height)

        animationView.animation = AnimationEnum.composition(for: .dragging)!
        animationView.contentMode = .scaleAspectFit
        animationContainer.addSubview(animationView)

        expandableCircle.backgroundColor = UIColor.clear
        expandableCircle.layer.cornerRadius = expandableCircle.frame.size.height/2
        expandableCircle.center = center

        addSubview(expandableCircle)
        addSubview(animationContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not implemented.")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard let grandparent = superview?.superview else { return }

        self.autoPinEdge(.top, to: .top, of: grandparent, withOffset: 0)
        self.autoPinEdge(.leading, to: .leading, of: grandparent)
        self.autoPinEdge(.trailing, to: .trailing, of: grandparent)
        animationContainer.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
        animationContainer.autoPinEdge(.bottom, to: .bottom, of: self)
        animationContainer.autoPinEdge(.leading, to: .leading, of: self)
        animationContainer.autoPinEdge(.trailing, to: .trailing, of: self)
        if !UIScreen.hasNotch {
            animationView.autoCenterInSuperview()
        }
        let heightConstraint = NSLayoutConstraint(item: animationView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1, constant: CGFloat(Constants.LoadingView.height))

        animationView.addConstraint(heightConstraint)
    }
    override func layoutSubviews() {
        if UIScreen.hasNotch {
            animationView.frame.origin.x = animationContainer.frame.midX - (animationView.frame.width / 2)
            if VFGRootViewController.shared.nudgeView.isHidden {
                animationView.frame.origin.y = self.frame.height / 2.5
            } else {
                animationView.frame.origin.y = (self.frame.height / 2) - (animationView.frame.height / 2)
            }
        }
    }
}

extension VFGPullToRefreshAnimatableView: VFGPullToRefreshAnimatableViewProtocol {
    func setInitialAnimationState() {
        animationView.animation = AnimationEnum.composition(for: .dragging)!
        animationView.loopMode = .playOnce
    }

    func performDraggingUpdates(with progress: CGFloat) {
        animationView.currentProgress = progress
    }

    func performLoadingAnimation() {
        animationView.animation = AnimationEnum.composition(for: .loading)!
        animationView.loopMode = .playOnce
        animationView.play { (_) in
            self.animationView.animation = AnimationEnum.composition(for: .loading2)!
            self.animationView.loopMode = .loop
            self.animationView.play()
        }
    }

    func performFinishedAnimation(_ completion: @escaping (Bool) -> Void) {

        animationView.animation = AnimationEnum.composition(for: .successTickOnline)!
        animationView.loopMode = .playOnce

        self.expandableCircle.backgroundColor = expandableCircleBgColor
        UIView.animate(withDuration: Constants.ExpandableCircle.duration, animations: {
            self.expandableCircle.transform = CGAffineTransform(scaleX: Constants.ExpandableCircle.scaleXTransformation,
                                                                y: Constants.ExpandableCircle.scaleYTransformation)
            self.expandableCircle.backgroundColor = UIColor.clear
        }, completion: { (_) in
            self.expandableCircle.transform = CGAffineTransform.identity
        })
        animationView.play()

        let delayTime = DispatchTime.now() +
            Double(Int64(Constants.ExpandableCircle.returnCallbackTimer * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion(true)
        }
    }
}
