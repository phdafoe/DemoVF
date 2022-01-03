//
//  VFGRootViewControllerComponents.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 12/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class VFGRootViewControllerComponents: NSObject {

    func statusBarManager() -> VFGRootViewStatusBarManager {
        return VFGRootViewStatusBarManager()
    }

    func sideMenuViewController(inViewController controller: UIViewController) -> VFGSideMenuViewController {
        return VFGSideMenuViewController.sideMenuViewController(inViewController: controller)
    }

}
