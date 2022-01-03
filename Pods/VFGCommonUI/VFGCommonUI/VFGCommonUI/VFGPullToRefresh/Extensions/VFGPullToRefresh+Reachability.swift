//
//  VFGPullToRefresh+Reachability.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 1/2/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils
import SystemConfiguration

internal extension VFGPullToRefreshControl {
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedNetworkStatus(_:)),
                                               name: NSNotification.Name.reachabilityChanged,
                                               object: nil)
        do {
            try reachability.startNotifier()
        } catch {
            VFGDebugLog("Unable to start")
        }
    }

    @objc private func changedNetworkStatus(_ notification: NSNotification) {
        hasConnection = reachability.connection != .none
    }
}
