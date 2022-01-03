//
//  VFGPanGestureHandler.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 07/11/16.
//  Copyright © 2016 Mich. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGLeftPanGestureHandler: NSObject, UIGestureRecognizerDelegate {

    private static let offsetThreasholdProportion: CGFloat = 0.5
    private static let velocityThreasholdValue: CGFloat = -300
    private static let maximumNumberOfTouches: Int = 1

    private var gestureStartPosition: CGFloat = 0
    private var velocity: CGFloat = 0
    private(set) var currentGestureOffset: CGFloat = 0

    private var currentMaxOffset: CGFloat = 0

    var maxOffsetForPointCallback : ((_ touchPoint: CGPoint) -> CGFloat)?
    var gestureStartedCallback : ((_ startPoint: CGPoint) -> Void)?
    var offsetChangedCallback : ((_ offset: CGFloat) -> Void)?
    var gestureFinishedCallback : ((_ shouldShowOptions: Bool) -> Void)?

    func makeGestureRecognizer() -> UIPanGestureRecognizer {
        let rec = UIPanGestureRecognizer(target: self,
                                         action: #selector(VFGLeftPanGestureHandler.handleGesture(gestureRecognizer:)))
        rec.maximumNumberOfTouches = VFGLeftPanGestureHandler.maximumNumberOfTouches
        rec.delegate = self
        return rec
    }

    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        VFGDebugLog("VFGLeftPanGestureHandler state:\(gestureRecognizer.state.rawValue)")
        switch gestureRecognizer.state {
        case .began:
            let startPosition: CGPoint = position(fromRecognizer: gestureRecognizer)
            gestureStarted(startPosition: startPosition)
            gestureStartPosition = startPosition.x
            velocity = gestureRecognizer.velocity(in: gestureRecognizer.view).x
        case .changed:
            let offset: CGFloat = computeAllowedGestureOffset(xLocation: position(fromRecognizer: gestureRecognizer).x)
            if !currentGestureOffset.equalsWithEpsilon(other: offset) {
                currentGestureOffset = offset
                gestureChanged()
            }
            velocity = gestureRecognizer.velocity(in: gestureRecognizer.view).x
        default:
            gestureFinished()
            reset()
        }

    }

    private func position(fromRecognizer recognizer: UIPanGestureRecognizer) -> CGPoint {
        return recognizer.location(in: recognizer.view)
    }

    private func gestureStarted(startPosition: CGPoint) {
        if let callback : ((_ startPoint: CGPoint) -> Void) = self.gestureStartedCallback {
            callback(startPosition)
        }
    }

    private func gestureChanged() {
        if let callback : ((_ offset: CGFloat) -> Void) = self.offsetChangedCallback {
            callback(self.currentGestureOffset)
        }
    }

    private func gestureFinished() {
        if let callback : ((_ shouldShowOptions: Bool) -> Void) = self.gestureFinishedCallback {
            callback(self.shouldShowOptions())
        }
        guard let userSwipedClosure = VFGSwipeableTableViewCell.userHasSwipedTrackEvent else {
            return
        }
        userSwipedClosure()
    }

    private func shouldShowOptions() -> Bool {
        return currentGestureOffset/currentMaxOffset > VFGLeftPanGestureHandler.offsetThreasholdProportion ||
            velocity < VFGLeftPanGestureHandler.velocityThreasholdValue
    }

    private func reset() {
        self.gestureStartPosition = 0
        self.currentGestureOffset = 0
        self.velocity = 0
    }

    private func computeAllowedGestureOffset(xLocation: CGFloat) -> CGFloat {
        let offsetToLeftFromStartPoint = max(self.gestureStartPosition - xLocation, 0)
        return min(offsetToLeftFromStartPoint, self.currentMaxOffset)
    }

    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                        shouldReceive touch: UITouch) -> Bool {
        var maxOffset: CGFloat = 0
        if let callback : ((_ touchPoint: CGPoint) -> CGFloat) = maxOffsetForPointCallback {
            let point = touch.location(in: gestureRecognizer.view)
            maxOffset = callback(point)
        }
        currentMaxOffset = maxOffset
        return currentMaxOffset != 0
    }

    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return gestureRecognizer.state != .began && gestureRecognizer.state != .possible
    }

    @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let recognizer: UIPanGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            VFGErrorLog("Cannot cast data to UIPanGestureRecognizer")
            return false
        }
        let velocity = recognizer.velocity(in: gestureRecognizer.view)
        return Swift.abs(velocity.x) > Swift.abs(velocity.y)
    }
}
