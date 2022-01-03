//
//  UIApplication+TopMostViewed.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 4/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
extension UIApplication {
    var topMostViewController: UIViewController? {
        return keyWindow?.rootViewController?.topMostViewController()
    }
}
