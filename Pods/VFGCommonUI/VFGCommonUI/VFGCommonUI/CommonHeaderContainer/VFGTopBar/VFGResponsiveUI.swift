//
//  VFGResponsiveUI.swift
//  VFGCommonUI
//
//  Created by kasa on 14/12/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 * Definitions for Notifications & userInfo keys for responsive UI elements
 */
@objc public class VFGResponsiveUI: NSObject {
    /**
     * Show inbox notification
     */
    @objc public static var onShowInboxNotification = NSNotification.Name("onShowInbox")
    /**
     * Badge refresh notification
     */
    @objc public static var onBadgeReshreshNotification = NSNotification.Name("onBadgeReshresh")
    /**
     * Badge string key in userInfo of onBadgeReshreshNotification
     */
    @objc public static var badgeStringKey = "badgeString"

}
