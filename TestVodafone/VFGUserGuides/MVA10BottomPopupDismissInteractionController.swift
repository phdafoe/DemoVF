//
//  MVA10BottomPopupDismissInteractionController.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

protocol MVA10BottomPopupDismissInteractionControllerDelegate: class {
    func dismissInteraction(_ controller: MVA10BottomPopupDismissInteractionCtr, didChangePercentFrom oldValue: CGFloat, to newValue: CGFloat)
}

class MVA10BottomPopupDismissInteractionCtr: UIPercentDrivenInteractiveTransition {
    private let VFMinPercentOfVisible = CGFloat(0.5)
    private let VFSwipeDownThreshold = CGFloat(1000)
    private weak var presentedViewController: MVA10BottomPresentableViewController?
    private weak var transitionDelegate: MVA10BottomPopupTransitionHandler?
    weak var delegate: MVA10BottomPopupDismissInteractionControllerDelegate?
    private var currentPercent: CGFloat = 0 {
        didSet {
            delegate?.dismissInteraction(self, didChangePercentFrom: oldValue, to: currentPercent)
        }
    }

    init(presentedViewController: MVA10BottomPresentableViewController?) {
        self.presentedViewController = presentedViewController
        self.transitionDelegate = presentedViewController?.transitioningDelegate as? MVA10BottomPopupTransitionHandler
        super.init()
        preparePanGesture(in: presentedViewController?.view)
    }

    private func finishAnimation(withVelocity velocity: CGPoint) {
        if currentPercent > VFMinPercentOfVisible
            || velocity.y > VFSwipeDownThreshold {
            finish()
        } else {
            cancel()
        }
    }

    private func preparePanGesture(in view: UIView?) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        presentedViewController?.view?.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        guard let presentedView = presentedViewController?.view else { return }
        let translationY = pan.translation(in: presentedView).y
        let translationPercent = translationY / presentedView.frame.size.height

        currentPercent = min(max(translationPercent, 0), 1)

        switch pan.state {
        case .began:
            transitionDelegate?.isInteractiveDismissStarted = true
            presentedViewController?.dismiss(animated: true, completion: nil)
        case .changed:
            update(currentPercent)
        default:
            let velocity = pan.velocity(in: presentedViewController?.view)
            transitionDelegate?.isInteractiveDismissStarted = false
            finishAnimation(withVelocity: velocity)
        }
    }
}
