//
//  VFGTopViewControllerHelper.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 17.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

/**
 This functions returns top view controller.
 - returns: UIViewController which is currently on the screen.
 
 */
public func getTopViewController() -> UIViewController? {
    if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        if topViewController is UIAlertController {
            // handle special case where top VC is Alert
            let window = UIWindow(frame: UIScreen.main.bounds)
            let blankVC =  UIViewController()
            blankVC.view.backgroundColor = .clear
            window.makeKeyAndVisible()
            window.rootViewController = blankVC
            return blankVC
        }
        return topViewController
    }
    VFGInfoLog("getTopViewController returns nil")
    return nil
}

/**
 This functions returns true if the current device is iPad.
 - returns: Bool which determines the device type
 */
public func isIPad() -> Bool {
    return UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
        UIScreen.main.traitCollection.verticalSizeClass == .regular
}
