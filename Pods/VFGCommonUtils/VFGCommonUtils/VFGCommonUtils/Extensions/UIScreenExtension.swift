//
//  UIScreenExtension.swift
//  VFGommonUtil
//
//  Created by Ehab Alsharkawy on 8/16/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

public extension UIScreen {

    // MARK: - Device Size Checks
    enum Heights: CGFloat {
        case inches35 = 480
        case inches4 = 568
        case inches47 = 667
        case inches55 = 736
        case inches58 = 812
    }

    enum Inches: String {
        case inches35 = "3.5 Inches"
        case inches4 = "4 Inches"
        case inches47 = "4.7 Inches"
        case inches55 = "5.5 Inches"
        case inches58 = "5.8 Inches"
        case other = "other"
    }

    static var currentSize: Inches {
        if IS_3_5_INCHES() {
            return .inches35
        } else if IS_4_INCHES() {
            return .inches4
        } else if IS_4_7_INCHES() {
            return .inches47
        } else if IS_5_5_INCHES() {
            return .inches55
        } else if IS_5_8_INCHES() {
            return .inches58
        }
        return .other
    }

    // MARK: - Singletons
    static var currentDevice: UIDevice {
        return  UIDevice.current
    }

    static var currentDeviceVersion: Float {
        return Float(currentDevice.systemVersion) ?? 0
    }

    static var currentDeviceHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static func isDeviceVersionIphoneXOrNewer() -> Bool {
        let height: CGFloat = 24
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
            // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > height
        }
        return false
    }

    // MARK: - Device Idiom Checks
    static var phoneOrPad: String {
        if isPhone {
            return "iPhone"
        } else if isIpad {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }

    static var debuOrRelease: String {
        #if DEBUG
        return "Debug"
        #else
        return "Release"
        #endif
    }

    static var simulatorOrDevice: String {
        #if targetEnvironment(simulator)
        return "Simulator"
        #else
        return "Device"
        #endif
    }

    @objc static var isPhone: Bool {
        return currentDevice.userInterfaceIdiom == .phone
    }

    @objc static var isIpad: Bool {
        return currentDevice.userInterfaceIdiom == .pad
    }

    static func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static func isRelease() -> Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }

    static func isSimulator() -> Bool {
        return simulatorOrDevice == "Simulator"
    }

    static func isDevice() -> Bool {
        return simulatorOrDevice == "Device"
    }

    static var currentVersion: String {
        return "\(currentDeviceVersion)"
    }

    static func isSize(height: Heights) -> Bool {
        return currentDeviceHeight == height.rawValue
    }

    // MARK: Retina Check
    static func IS_RETINA() -> Bool {
        return UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
    }

    // MARK: 3.5 Inch Checks
    static func IS_3_5_INCHES() -> Bool {
        return isPhone && isSize(height: .inches35)
    }

    // MARK: 4 Inch Checks
    static func IS_4_INCHES() -> Bool {
        return isPhone && isSize(height: .inches4)
    }

    // MARK: 4.7 Inch Checks
    static func IS_4_7_INCHES() -> Bool {
        return isPhone && isSize(height: .inches47)
    }

    // MARK: 5.5 Inch Checks
    static func IS_5_5_INCHES() -> Bool {
        return isPhone && isSize(height: .inches55)
    }

    // MARK: 5.8 Inch Checks
    static func IS_5_8_INCHES() -> Bool {
        return isPhone && isSize(height: .inches58)
    }
}
