//
//  VFGTopBarScrollState.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 05/02/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Class responsible for changing position and visual appearance of top bar based on given scroll offset
 */
@objc public class VFGTopBarScrollState: NSObject {

    /**
     Top bar displayed at top of the screen
     */
    var topBar: VFGTopBar? {
        didSet {
            stateManager.topBar = topBar
        }
    }

    /**
     Initial y origin of top bar, when there is no scroll offset
     */
    @objc public var topBarInitialY: CGFloat = VFGCommonUISizes.statusBarHeight {
        didSet {
            stateManager.state.parameters = makeParameters()
        }
    }

    /**
     Y scroll offset from which to start changing background alpha to transparent
     */
    @objc public var alphaChangeYPosition: CGFloat = 0 {
        didSet {
            stateManager.state.parameters = makeParameters()
        }
    }

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
        if Swift.abs(currentYOffset - offset) < VFGTopBarScrollState.floatDiffEpsilon {
            VFGDebugLog("Aborting VFGTopBarScrollDelegate didScroll.")
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

    var topBarOriginY: CGFloat {
        return stateManager.state.topBarOriginY
    }

    var isNoOffset: Bool {
        return isInitialState && isInitialOffset
    }

    private var isInitialState: Bool {
        return type(of: stateManager.state) == VFGTopBarScrollingState.self
    }

    private var isInitialOffset: Bool {
        return currentYOffset == 0
    }

    private static let floatDiffEpsilon: CGFloat = 0.0001
    private var currentYOffset: CGFloat = 0

    private lazy var stateManager: VFGTopBarStateManager = {
        return VFGTopBarStateManager(parameters: makeParameters())
    }()

    private func makeParameters() -> VFGTopBarConfigurationParameters {
        return VFGTopBarConfigurationParameters(initialY: topBarInitialY,
                                                lastOffset: currentYOffset,
                                                alphaChangeStartOffset: alphaChangeYPosition)
    }
}
