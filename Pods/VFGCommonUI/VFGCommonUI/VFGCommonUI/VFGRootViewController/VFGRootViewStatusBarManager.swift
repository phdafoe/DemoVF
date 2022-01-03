//
//  VFGRootViewStatusBarManager.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 11/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Style of status bar background.

 - black: status bar with black background
 - transparent: status bar with transparent background

 */
public enum VFGRootViewControllerStatusBarState {
    /**
     Status bar with black background
     */
    case black
    /**
     Status bar with transparent background
     */
    case transparent
    /**
     Status bar with transparent background at the top of the view controller and with opaque background while scrolling
     */
    case iPhoneXStatusBar

    public static var defaultState: VFGRootViewControllerStatusBarState {
        return UIScreen.hasNotch ? .iPhoneXStatusBar : .black
    }

}

class VFGRootViewStatusBarManager: NSObject {

    public var parallaxEffectEnabled: Bool = true
    public var customizedBarBGColor: UIColor? {
        didSet {
            update()
        }
    }
    var statusBarBackgroundView: UIView? {
        didSet {
            update()
        }
    }

    var alpha: CGFloat = 0.85 {
        didSet {
            if oldValue != alpha {
                update()
            }
        }
    }

    var statusBarState: VFGRootViewControllerStatusBarState = .black {
        didSet {
            if oldValue != statusBarState {
                update()
            }
        }
    }

    private func update() {
        switch self.statusBarState {
        case .black:
            statusBarBackgroundView?.backgroundColor = parallaxEffectEnabled ? UIColor.black : customizedBarBGColor
        case .iPhoneXStatusBar:
            statusBarBackgroundView?.backgroundColor = customizedBarBGColor ?? UIColor.VFGTopBarBackgroundColor
            statusBarBackgroundView?.alpha = parallaxEffectEnabled ? alpha : 1
        default:
            statusBarBackgroundView?.backgroundColor = parallaxEffectEnabled ?  UIColor.clear : customizedBarBGColor
        }
    }

}
