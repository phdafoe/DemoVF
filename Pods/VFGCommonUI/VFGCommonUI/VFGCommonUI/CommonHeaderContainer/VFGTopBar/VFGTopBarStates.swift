//
//  VFGTopBarState.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 28/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGTopBarState {

    enum State {
        case unknown
        case scrolling
        case offscreen
        case showing
        case hiding
        case opaque
        case alpha
    }

    var topBarOriginY: CGFloat {
        return topBarFrame(parameters.lastOffset).minY
    }
    var nextState: State = .unknown
    var topBar: VFGTopBar?
    var parameters: VFGTopBarConfigurationParameters
    var stateFinishedCallback : ((_ nextState: State, _ parameters: VFGTopBarConfigurationParameters) -> Void)?

    required init(parameters: VFGTopBarConfigurationParameters) {
        self.parameters = parameters
    }

    func didScroll(withOffset offset: CGFloat) {

    }

    func start() {
        update()
    }

    func update() {
        updateTopBar(parameters.lastOffset)
    }

    func finishMe(nextState: State, offset: CGFloat) {
        VFGDebugLog("nextState:\(nextState) offset:\(offset)")
        self.nextState = nextState
        updateLastOffset(offset)
        if let callback : ((_ nextState: State,
            _ parameters: VFGTopBarConfigurationParameters) -> Void) = self.stateFinishedCallback {
            callback(self.nextState, self.parameters)
        } else {
            VFGDebugLog("VFGTopBar stateFinishedCallback is not set")
        }
    }

    func updateLastOffset(_ offset: CGFloat) {
        parameters.lastOffset = offset
    }

    func updateTopBar(_ offset: CGFloat) {
        topBar?.frame = topBarFrame(offset)
        topBar?.opaqueBackgroundAlpha = topBarScrollBackgroundAlpha(offset)
    }

    func topBarFrame(_ offset: CGFloat) -> CGRect {
        return topBarBounds()
    }

    func topBarScrollBackgroundAlpha(_ offset: CGFloat) -> CGFloat {
        return 0
    }

    fileprivate func topBarBounds() -> CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: VFGTopBar.topBarHeight)
    }

}

class VFGTopBarScrollingState: VFGTopBarState {

    override func didScroll(withOffset offset: CGFloat) {
        if shouldMoveToOffscreen(offset: offset) {
            finishMe(nextState: .offscreen, offset: offset)
        } else {
            updateTopBar(offset)
            updateLastOffset(offset)
        }
    }

    private func shouldMoveToOffscreen(offset: CGFloat) -> Bool {
        return offset > parameters.alphaChangeStartOffset
    }

    override func topBarFrame(_ offset: CGFloat) -> CGRect {
        return parameters.offsetFrame(frame: topBarBounds(), offset: offset)
    }

}

class VFGTopBarOffscreenState: VFGTopBarState {

    override func didScroll(withOffset offset: CGFloat) {
        if self.shouldStartScrolling(offset: offset) {
            self.finishMe(nextState: .scrolling, offset: offset)
        } else if self.parameters.isScrollingDown(offset) {
            self.finishMe(nextState: .showing, offset: offset)
        } else {
            self.updateTopBar(offset)
            self.updateLastOffset(offset)
        }
    }

    private func shouldStartScrolling(offset: CGFloat) -> Bool {
        return offset <= VFGTopBar.topBarHeight
    }

    override func topBarFrame(_ offset: CGFloat) -> CGRect {
        return self.parameters.offscreenFrame(frame: self.topBarBounds())
    }
}

class VFGTopBarOpaqueState: VFGTopBarState {

    override func didScroll(withOffset offset: CGFloat) {
        if self.parameters.isScrollingUp(offset) {
            self.finishMe(nextState: .hiding, offset: offset)
        } else if self.parameters.shouldStartAlphaChange(offset: offset) {
            self.finishMe(nextState: .alpha, offset: offset)
        } else {
            self.updateTopBar(offset)
            self.updateLastOffset(offset)
        }
    }

    override func topBarFrame(_ offset: CGFloat) -> CGRect {
        return parameters.initialFrame(frame: topBarBounds())
    }

    override func topBarScrollBackgroundAlpha(_ offset: CGFloat) -> CGFloat {
        return VFGTopBarConfigurationParameters.topBarOpaqueOpacity
    }

}

class VFGTopBarAlphaState: VFGTopBarState {

    override func didScroll(withOffset offset: CGFloat) {
        if shouldStartScrollingTopBar(offset: offset) {
            finishMe(nextState: .scrolling, offset: offset)
        } else if parameters.shouldStartAlphaChange(offset: offset) == false {
            finishMe(nextState: .opaque, offset: offset)
        } else {
            if offset > 0.0 {
                VFGRootViewController.shared.statusBarAlpha = self.parameters.alphaForOffset(offset)
                updateTopBar(offset)
                updateLastOffset(offset)
            } else {
                finishMe(nextState: .scrolling, offset: offset)
            }
        }
    }

    private func shouldStartScrollingTopBar(offset: CGFloat) -> Bool {
        return offset == 0
    }

    override func topBarFrame(_ offset: CGFloat) -> CGRect {
        return parameters.initialFrame(frame: topBarBounds())
    }

    override func topBarScrollBackgroundAlpha(_ offset: CGFloat) -> CGFloat {
        return parameters.alphaForOffset(offset)
    }
}

class VFGTopBarAnimateState: VFGTopBarState {

    static let animationDuration = 0.2

    override func start() {
        animate()
    }

    func animate() {
        updateTopBarAlpha()
        UIView.animate(withDuration: VFGTopBarAnimateState.animationDuration,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: animation(),
                       completion: animationCompletion())
    }

    func updateTopBarAlpha() {

    }

    func animation() -> () -> Void {
        return { () in }
    }

    func animationCompletion() -> (_ completed: Bool) -> Void {
        return { (_ : Bool) in }
    }

}

class VFGTopBarAnimateShowingState: VFGTopBarAnimateState {

    override func didScroll(withOffset offset: CGFloat) {
        if self.parameters.isScrollingUp(offset) {
            self.finishMe(nextState: .hiding, offset: offset)
        } else if self.parameters.isScrollingDown(offset) && offset <= 0 {
            self.finishMe(nextState: .scrolling, offset: offset)
        } else {
            self.updateLastOffset(offset)
        }
    }

    override func updateTopBarAlpha() {
        self.topBar?.opaqueBackgroundAlpha = VFGTopBarConfigurationParameters.topBarOpaqueOpacity
    }

    override func animation() -> () -> Void {
        return { () -> Void in
            self.topBar?.frame = self.parameters.initialFrame(frame: self.topBarBounds())
        }
    }

    override func animationCompletion() -> (_ completed: Bool) -> Void {
        return { (completed: Bool) -> Void in
            if self.nextState == .unknown {
                self.finishMe(nextState: .opaque, offset: self.parameters.lastOffset)
            }
        }
    }
}

class VFGTopBarAnimateHiddingState: VFGTopBarAnimateState {

    override func didScroll(withOffset offset: CGFloat) {
        if self.parameters.isScrollingDown(offset) {
            self.finishMe(nextState: .showing, offset: offset)
        } else {
            self.updateLastOffset(offset)
        }
    }

    override func updateTopBarAlpha() {
        self.topBar?.opaqueBackgroundAlpha = VFGTopBarConfigurationParameters.topBarOpaqueOpacity
    }

    override func animation() -> () -> Void {
        return { () -> Void in
            self.topBar?.frame = self.parameters.offscreenFrame(frame: self.topBarBounds())
        }
    }

    override func animationCompletion() -> (_ completed: Bool) -> Void {
        return { (completed: Bool) -> Void in
            if self.nextState == .unknown {
                self.finishMe(nextState: .offscreen, offset: self.parameters.lastOffset)
            }
        }
    }
}
