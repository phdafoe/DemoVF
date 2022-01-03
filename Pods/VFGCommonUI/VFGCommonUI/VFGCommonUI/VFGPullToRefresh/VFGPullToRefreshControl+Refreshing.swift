//
//  VFGPullToRefreshControl+Refreshing.swift
//  VFGCommonUI
//
//  Created by Mohamed Abd ElNasser on 1/21/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

// MARK: - Refreshing
extension VFGPullToRefreshControl {
    func startRefreshing() {
        if state != .initial {
            return
        }
        guard let scrollView = scrollView else { return }
        state = .loading
        let offsetY: CGFloat = calculateVerticalOffset(scrollView)
        scrollView.configure(offset: offsetY)
    }

    func calculateVerticalOffset(_ view: UIScrollView) -> CGFloat {
        var offsetY: CGFloat = 0
        offsetY -= RefreshableView.height
        offsetY -= scrollViewDefaultInsets.top
        if offlineRibbonView.isVisible {
            offsetY -= OfflineRibbonView.height
        }
        if #available(iOS 11, *) {
            offsetY -= view.safeAreaInsets.top
        }
        return offsetY
    }

    func stopRefreshing(failureMessage: String? = nil) {
        if state == .loading {
            if let message = failureMessage {
                state = .failedWithErrorMessage(message: message)
            } else {
                state = .finished
            }
        }
    }
}

fileprivate extension UIScrollView {
    func configure(offset: CGFloat) {
        contentInset.top = -offset
        setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }
}
