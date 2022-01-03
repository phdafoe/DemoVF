//
//  UIScreen+Notch.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 27/03/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIScreen {

    @objc public static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            // notch devices has safeArea bottom inset greater than 0 in both orientations
            let window: UIWindow? = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
            return window?.safeAreaInsets.bottom ?? 0 > 0
        } else {
            // devices which support iOS10 and older doesn't have notch
            return false
        }
    }

}
