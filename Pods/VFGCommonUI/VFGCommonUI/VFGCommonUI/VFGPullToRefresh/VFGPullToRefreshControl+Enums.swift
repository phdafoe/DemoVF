//
//  VFGPullToRefreshControl+Extensions.swift
//  VFGCommonUI
//
//  Created by Mohamed ELMeseery on 12/26/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

/// **State pattern** which represents the different states are part of the **pull to refresh** component.
///
/// - initial: Represents the `no event` state, when scrollable view offset is `0`.
/// - dragging: Dragging event representation of the scrollable view (any offset lower than `0`).
/// - offline: Representation of the `offline` state (when the user stopped dragging and has not a network
///            connection).
/// - loading: Representation of the `loading` state (when the user stopped dragging and has a network connection).
/// - finished: Representation of the `finished` state.
/// - failedWithMessage: Representation of the `failedWithMessage` state.
enum State: Equatable {
    case initial
    case dragging(progress: CGFloat)
    case offline
    case loading
    case finished
    case failedWithErrorMessage(message: String)

    public static func == (left: State, right: State) -> Bool {
        switch (left, right) {
        case (.initial, .initial),
             (.dragging, .dragging),
             (.loading, .loading),
             (.finished, .finished),
             (.failedWithErrorMessage, .failedWithErrorMessage):
            return true
        default:
            return false
        }
    }
}

enum RefreshableView {
    static let height: CGFloat = UIScreen.hasNotch ? 90 : 60
}

enum SuccessTick {
    static let duration: Double = 0.69
}

enum LoadingState {
    static let duration: TimeInterval = 0.3
}

enum ShakeAnimation {
    static let duration: Double = 0.05
}

enum FinishedState {
    static let duration: TimeInterval = 0.3
    static let delay: TimeInterval = 0
    static let animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
}

enum OfflineRibbonView {
    static let height: CGFloat = 51
    static let heightZero: CGFloat = 0.0
}
