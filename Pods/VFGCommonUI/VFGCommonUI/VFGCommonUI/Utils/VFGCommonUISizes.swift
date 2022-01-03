//
//  VFGCommonUISizes.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 20/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Common sizes for UI components and device elements.
 */
@objc public class VFGCommonUISizes: NSObject {

    /**
     Height of status bar.
     */
    @objc public static var statusBarHeight: CGFloat {
        return UIScreen.hasNotch ? 44 : 20
    }

    /**
     Clickable area size.
     */
    @objc static public let minClickableAreaSize: CGFloat = 44

}
