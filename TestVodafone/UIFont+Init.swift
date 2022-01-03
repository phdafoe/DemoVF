//
//  UIFont+Vodafone.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 16/05/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGCommonUI

/// A `UIFont` extension which allows automation of the process to select custom font files
extension UIFont {
    private enum VFGFontName: String {
        case regular = "VodafoneRg-Regular"
        case lite = "VodafoneLt-Regular"
        case bold = "VodafoneRg-Bold"

        var fileName: String {
            switch self {
            case .regular:
                return VFGFontFileName.regular.rawValue
            case .lite:
                return VFGFontFileName.lite.rawValue
            case .bold:
                return VFGFontFileName.bold.rawValue
            }
        }
    }

    private enum VFGFontFileName: String {
        case regular = "vodafone-regular"
        case lite = "vodafone-lite"
        case bold = "vodafone-bold"
    }
    /// Apply **vodafone-regular** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneRegular(_ size: CGFloat) -> UIFont {
        return vodafoneFont(size: size, type: .regular)
    }

    /// Apply **vodafone-lite** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneLite(_ size: CGFloat) -> UIFont {
        return vodafoneFont(size: size, type: .lite)
    }

    /// Apply **vodafone-bold** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneBold(_ size: CGFloat) -> UIFont {
        return vodafoneFont(size: size, type: .bold)
    }

    private class func vodafoneFont(size: CGFloat, type: VFGFontName) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            registerFont(name: type.fileName)
            return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        return font
    }

    private static func registerFont(name: String) {
        guard let pathForResourceString = Bundle.foundation.path(forResource: name, ofType: "ttf"),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider) else {
                return
        }
        var error: UnsafeMutablePointer<Unmanaged<CFError>?>?
        if CTFontManagerRegisterGraphicsFont(fontRef, error) == false {
            return
        }
        error = nil
    }
}
