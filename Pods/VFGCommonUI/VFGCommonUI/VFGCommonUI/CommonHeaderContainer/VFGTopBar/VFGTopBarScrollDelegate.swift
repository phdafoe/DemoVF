//
//  VFGCommonTopBarScrollHandler.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 24/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Delegate responsible for changing position and visual appearance of top bar based on given scroll offset
 */
@available(*, deprecated, renamed: "VFGTopBarScrollState")
@objc public class VFGTopBarScrollDelegate: NSObject {

    private static let floatDiffEpsilon: CGFloat = 0.0001
    /**
     Top bar displayed at top of the screen
     */
    var topBar: VFGTopBar? {
        didSet {
            self.stateManager.topBar = self.topBar
        }
    }

    /**
     Initial y origin of top bar, when there is no scroll offset
     */
    @objc public var topBarInitialY: CGFloat = VFGCommonUISizes.statusBarHeight {
        didSet {
            self.stateManager.state.parameters = self.makeParameters()
        }
    }

    /**
     Y scroll offset from which to start changing background alpha to transparent
     */
    @objc public var alphaChangeYPosition: CGFloat = 0 {
        didSet {
            self.stateManager.state.parameters = self.makeParameters()
        }
    }

    var topBarOriginY: CGFloat {
        return self.stateManager.state.topBarOriginY
    }

    var isNoOffset: Bool {
        return self.isInitialState1 && self.isInitialOffset
    }

    private var isInitialState1: Bool {
        return type(of: self.stateManager.state) == VFGTopBarScrollingState.self
    }

    private var isInitialOffset: Bool {
        return self.currentYOffset == 0
    }

    private var currentYOffset: CGFloat = 0

    private lazy var stateManager: VFGTopBarStateManager = {
        return VFGTopBarStateManager(parameters: self.makeParameters())
    }()

    /**
     Call to update current state, position and opacity of a top bar.
     */
    @objc public func refresh() {
        self.stateManager.didScroll(withOffset: self.currentYOffset)
    }

    @objc public func getStatusBarAlpha() -> CGFloat {
        return stateManager.getStatusBarAlpha()
    }

    /**
     Call to inform delegate that view offset has changed and thus top bar position,
     - Parameter withOffset: Current scroll offset
     */
    @objc public func didScroll(withOffset offset: CGFloat) {
        if fabs(currentYOffset - offset) < VFGTopBarScrollDelegate.floatDiffEpsilon {
            VFGErrorLog("Aborting VFGTopBarScrollDelegate didScroll.")
            return
        }

        stateManager.didScroll(withOffset: offset)
        currentYOffset = offset
        if isInitialOffset {
            if UIScreen.hasNotch {
                VFGRootViewController.shared.statusBarAlpha = 0
            }
        }
    }

    private func makeParameters() -> VFGTopBarConfigurationParameters {
        return VFGTopBarConfigurationParameters(initialY: topBarInitialY,
                                                lastOffset: currentYOffset,
                                                alphaChangeStartOffset: alphaChangeYPosition)
    }
}
