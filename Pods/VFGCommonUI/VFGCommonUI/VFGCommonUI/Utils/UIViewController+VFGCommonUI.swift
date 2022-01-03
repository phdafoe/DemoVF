//
//  UIViewController+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 17/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import ObjectiveC
import VFGCommonUtils

/**
 Additions to view controller which help to use VFGCommonUI features.
 */
@objc public extension UIViewController {

    /**
     Root view controller to which stack this view controller is added. nil if view controller is not added to stack.
     */
    var rootViewController: VFGRootViewController? {
        var controller: UIViewController? = self.parent
        while controller != nil {
            if let controller: VFGRootViewController = controller as? VFGRootViewController {
                return controller
            }
            controller = controller?.parent
        }
        VFGInfoLog("rootViewController returns nil")
        return nil
    }
}
