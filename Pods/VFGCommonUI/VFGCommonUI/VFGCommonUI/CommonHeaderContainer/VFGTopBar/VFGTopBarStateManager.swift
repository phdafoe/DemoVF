//
//  VFGTopBarStateManager.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 28/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGTopBarStateManager {

    var topBar: VFGTopBar? {
        didSet {
            self.state.topBar = self.topBar
        }
    }
    private(set) var state: VFGTopBarState
    private var currentState: VFGTopBarState.State = .hiding
    private var currentAlpha: CGFloat = 0
    private var statusBarOpaqueAlpha = VFGTopBarConfigurationParameters.topBarOpaqueOpacity
    private var currentParameters: VFGTopBarConfigurationParameters
    private lazy var stateFinishedCallback : (_
        nextState: VFGTopBarState.State,
        _ parameters: VFGTopBarConfigurationParameters) -> Void = {
            return { [unowned self] nextState, parameters -> Void in
                self.state = self.makeState(forState: nextState, parameters: parameters)
                self.state.stateFinishedCallback = self.stateFinishedCallback
                self.state.start()
            }
    }()

    required init(parameters: VFGTopBarConfigurationParameters) {
        self.state = VFGTopBarScrollingState(parameters: parameters)
        currentParameters = parameters
        self.state.stateFinishedCallback = self.stateFinishedCallback
    }

    func didScroll(withOffset offset: CGFloat) {
        self.state.didScroll(withOffset: offset)
        currentAlpha = currentParameters.alphaForOffset(offset)
    }

    private func makeScrollingState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarScrollingState {
        let state: VFGTopBarScrollingState = VFGTopBarScrollingState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func makeOffscreenState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarOffscreenState {
        let state: VFGTopBarOffscreenState = VFGTopBarOffscreenState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func makeOpaqueState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarOpaqueState {
        let state: VFGTopBarOpaqueState = VFGTopBarOpaqueState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func makeAlphaState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarAlphaState {
        let state: VFGTopBarAlphaState = VFGTopBarAlphaState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func makeAnimateShowingBarState(parameters: VFGTopBarConfigurationParameters) ->
        VFGTopBarAnimateShowingState {
        let state: VFGTopBarAnimateShowingState = VFGTopBarAnimateShowingState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func makeHideAnimatingTopBarState(parameters: VFGTopBarConfigurationParameters) ->
        VFGTopBarAnimateHiddingState {
        let state: VFGTopBarAnimateHiddingState = VFGTopBarAnimateHiddingState(parameters: parameters)
        state.topBar = self.topBar
        return state
    }

    private func adjustStatusBar(opaque: Bool) {
        if UIScreen.hasNotch {
            if opaque {
                VFGRootViewController.shared.statusBarAlpha = statusBarOpaqueAlpha
            }
        }
    }

    func makeState(forState state: VFGTopBarState.State, parameters: VFGTopBarConfigurationParameters) ->
        VFGTopBarState {
        currentState = state
        switch state {
        case .alpha:
            adjustStatusBar(opaque: false)
            return self.makeAlphaState(parameters: parameters)
        case .offscreen:
            adjustStatusBar(opaque: true)
            return self.makeOffscreenState(parameters: parameters)
        case .opaque:
            adjustStatusBar(opaque: true)
            return self.makeOpaqueState(parameters: parameters)
        case .showing:
            adjustStatusBar(opaque: true)
            return self.makeAnimateShowingBarState(parameters: parameters)
        case .hiding:
            adjustStatusBar(opaque: false)
            return self.makeHideAnimatingTopBarState(parameters: parameters)
        default:
            adjustStatusBar(opaque: false)
            return self.makeScrollingState(parameters: parameters)
        }
    }

    func getStatusBarAlpha() -> CGFloat {
        switch currentState {
        case .alpha:
            return currentAlpha
        case .opaque, .showing, .offscreen:
            return statusBarOpaqueAlpha
        default:
            return 0
        }
    }
}
