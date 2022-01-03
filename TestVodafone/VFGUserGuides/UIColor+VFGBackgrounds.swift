//
//  UIColor+VFGBackgrounds.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGWhiteBackground = UIColor.init(
        named: "VFGWhiteBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #222222
    */
    public static let VFGWhiteBackgroundTwo = UIColor.init(
        named: "VFGWhiteBackgroundTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #222222
    */
    public static let VFGVeryLightGreyBackground = UIColor.init(
        named: "VFGVeryLightGreyBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #990000
    */
    public static let VFGRedBackground = UIColor.init(
        named: "VFGRedBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #F4F4F4
    - Dark color (Hex) #212121
    */
    public static let VFGLightGreyBackground = UIColor.init(
        named: "VFGLightGreyBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #E60000
    public static let VFGRedDefaultBackground = UIColor.init(
        named: "VFGRedDefaultBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #007B92
    public static let VFGAquaBackground = UIColor.init(
        named: "VFGAquaBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static let VFGWhiterAquaBackground = UIColor.init(
        named: "VFGWhiterAquaBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static var quickActionsGradient: [CGColor] {
        return [
            UIColor(red: 255 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0).cgColor,
            UIColor(red: 169 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0).cgColor
        ]
    }
    public static var giftOverlayGradient: [CGColor] {
        return [
            UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0).cgColor,
            UIColor(red: 244 / 255, green: 244 / 255, blue: 244 / 255, alpha: 1.0).cgColor
        ]
    }

   
    public static var VFGBackgroundRedGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneRed.cgColor,
            UIColor.VFGVodafoneMaroon.cgColor
        ]
    }
    public static var VFGDashBoardGradient: [CGColor] {
        return [
            UIColor.VFGVodafonePlatinum.cgColor,
            UIColor.VFGVodafoneLightGrey.cgColor
        ]
    }

    public static var VFGDashBoardLightGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneLightPlatinum.cgColor,
            UIColor.VFGVeryLightGreyLightBackground.cgColor
        ]
    }

    public static var VFGDashBoardDarkGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneDarkPlatinum.cgColor,
            UIColor.VFGVeryLightGreyDarkBackground.cgColor
        ]
    }

    public static var VFGDiscoverRedGradient: [CGColor] {
        return [
            UIColor.VFGRedDefaultBackground.cgColor,
            UIColor.VFGRedBackgroundTwo.cgColor
        ]
    }
    public static var VFGCVMBlueGradient: [CGColor] {
        return [
            UIColor.VFGWhiterAquaBackground.cgColor,
            UIColor.VFGAquaBackground.cgColor
        ]
    }
    public static var VFGVodafoneMaroon = UIColor.init(
        named: "VFGVodafoneMaroon",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    public static var VFGVodafoneRed = UIColor.init(
        named: "VFGVodafoneRed",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.red

    public static var VFGVodafonePlatinum = UIColor.init(
        named: "VFGVodafonePlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    public static var VFGVodafoneLightGrey = UIColor.init(
        named: "VFGVodafoneLightGrey",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    public static var VFGRedBackgroundTwo = UIColor.init(
        named: "VFGRedBackgroundTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    public static let VFGStatusBarBackground = UIColor.init(
        named: "VFGStatusBarBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static let VFGVeryLightGreyLightBackground = UIColor.init(
        named: "VFGVeryLightGreyLightBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static let VFGVeryLightGreyDarkBackground = UIColor.init(
        named: "VFGVeryLightGreyDarkBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static let VFGVodafoneLightPlatinum = UIColor.init(
        named: "VFGVodafoneLightPlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    public static let VFGVodafoneDarkPlatinum = UIColor.init(
        named: "VFGVodafoneDarkPlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
