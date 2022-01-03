//
//  UIViewController+TopMostViewed.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 4/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UIViewController {
    func topMostViewController() -> UIViewController {

        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }

        return self
    }
}
