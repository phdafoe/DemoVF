//
//  UIViewController+Init.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 20/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension UIViewController {
    private static let rootViewControllerStoryboardName = "VFGRootViewControllerStoryboard"
    private static let rootViewControllerStoryboardId = "VFGRootViewController"
    private static let alertViewStoryboardName: String = "VFGAlertViewController"
    private static let alertViewControllerStoryboardId: String = "AlertViewController"
    private static let configurableAlertStoryboardId: String = "ConfigurableAlertView"
    private static let commonHeaderStoryboardName: String = "VFGCommonHeaderContainer"
    private static let commonHeaderStoryboardId: String = "VFGCommonHeaderContainerController"
    private static let sideMenuStoryboardName: String = "VFGSideMenu"
    private static let sideMenuStoryboardId: String = "VFGSideMenuViewController"

    class func rootViewController() -> VFGRootViewController {
        return VFGRootViewController.viewController(from: rootViewControllerStoryboardName,
                                             with: rootViewControllerStoryboardId,
                                             bundle: Bundle.vfgCommonUI)
    }

    class func alertViewController() -> VFGAlertViewController {
        return VFGAlertViewController.viewController(from: VFGAlertViewController.alertViewStoryboardName,
                                                     with: VFGAlertViewController.alertViewControllerStoryboardId,
                                                     bundle: Bundle.vfgCommonUI)
    }

    class func configurableAlertViewController() -> VFGConfigurableAlertView {
        let storyboard = UIStoryboard(name: configurableAlertStoryboardId, bundle: Bundle.vfgCommonUI)
        guard let alertView = storyboard.instantiateInitialViewController() as? VFGConfigurableAlertView else {
            return VFGConfigurableAlertView()
        }
        return alertView
    }

    class func commonHeaderViewController() -> VFGCommonHeaderContainerController {
        return VFGCommonHeaderContainerController.viewController(from: commonHeaderStoryboardName,
                                                                 with: commonHeaderStoryboardId,
                                                                 bundle: Bundle.vfgCommonUI)
    }

    class func sideMenuViewController() -> VFGSideMenuViewController {
        return VFGSideMenuViewController.viewController(from: sideMenuStoryboardName,
                                                        with: sideMenuStoryboardId,
                                                        bundle: Bundle.vfgCommonUI)
    }

}
