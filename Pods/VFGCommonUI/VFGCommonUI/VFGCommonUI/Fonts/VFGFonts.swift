//
//  VFGFonts.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 16.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

public extension UIFont {

    private static let regularFontFilename = "vodafone-regular"
    private static let regularFontName = "VodafoneRg-Regular"

    private static let regularLiteFontFilename = "Vodafone_Lt"
    private static let regularLiteFontName = "VodafoneLt-Regular"

    private static let boldFontFilename = "vodafone-bold"
    private static let boldFontName = "VodafoneRg-Bold"

    private static let fontExtension = "ttf"

    private static let XXXXL: CGFloat = 30
    private static let XXXL: CGFloat = 28
    private static let XXL: CGFloat = 24
    // swiftlint:disable identifier_name
    private static let XL: CGFloat = 20
    private static let L: CGFloat = 18
    private static let M: CGFloat = 16
    private static let S: CGFloat = 14
    // swiftlint:enable identifier_name

    private static func registerFont(_ fontName: String) {
        guard let pathForResourceString = Bundle.vfgCommonUI.path(forResource: fontName, ofType: fontExtension) else {
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            return
        }

        guard let fontRef = CGFont(dataProvider) else {
            return
        }
        var error: UnsafeMutablePointer<Unmanaged<CFError>?>?
        if CTFontManagerRegisterGraphicsFont(fontRef, error) == false {
            return
        }
        error = nil
    }

    /**
     This method provides regular Vodafone font with size XXXX-Large.
     */
    @objc static func VFGXXXXL() -> UIFont? {
        return UIFont.vodafoneRegularFont(XXXXL)
    }

    /**
     This method provides bold Vodafone font with size XXXX-Large.
     */
    @objc static func VFGXXXXLBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(XXXXL)
    }

    /**
     This method provides light Vodafone font with size XXXX-Large.
     */
    @objc static func VFGXXXXLLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(XXXXL)
    }

    /**
     This method provides regular Vodafone font with size XXX-Large.
     */
    @objc static func VFGXXXL() -> UIFont? {
        return UIFont.vodafoneRegularFont(XXXL)
    }

    /**
     This method provides bold Vodafone font with size XXX-Large.
     */
    @objc static func VFGXXXLBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(XXXL)
    }

    /**
     This method provides light Vodafone font with size XXX-Large.
     */
    @objc static func VFGXXXLLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(XXXL)
    }

    /**
     This method provides light Vodafone font with size XX-Large.
     */
    @objc static func VFGXXL() -> UIFont? {
        return UIFont.vodafoneRegularFont(XXL)
    }

    /**
     This method provides bold Vodafone font with size XX-Large.
     */
    @objc static func VFGXXLBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(XXL)
    }

    /**
     This method provides light Vodafone font with size XX-Large.
     */
    @objc static func VFGXXLLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(XXL)
    }

    /**
     This method provides light Vodafone font with size X-Large.
     */
    @objc static func VFGXL() -> UIFont? {
        return UIFont.vodafoneRegularFont(XL)
    }

    /**
     This method provides bold Vodafone font with size X-Large.
     */
    @objc static func VFGXLBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(XL)
    }

    /**
     This method provides light Vodafone font with size X-Large.
     */
    @objc static func VFGXLLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(XL)
    }

    /**
     This method provides regular Vodafone font with size Large.
     */
    @objc static func VFGL() -> UIFont? {
        return UIFont.vodafoneRegularFont(L)
    }

    /**
     This method provides bold Vodafone font with size Large.
     */
    @objc static func VFGLBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(L)
    }

    /**
     This method provides light Vodafone font with size Large.
     */
    @objc static func VFGLLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(L)
    }

    /**
     This method provides regular Vodafone font with size medium.
     */
    @objc static func VFGM() -> UIFont? {
        return UIFont.vodafoneRegularFont(M)
    }

    /**
     This method provides bold Vodafone font with size medium.
     */
    @objc static func VFGMBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(M)
    }

    /**
     This method provides light Vodafone font with size medium.
     */
    @objc static func VFGMLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(M)
    }

    /**
     This method provides regular Vodafone font with size small.
     */
    @objc static func VFGS() -> UIFont? {
        if UIScreen.main.bounds.size.height <= 667.0 {
            return UIFont.vodafoneRegularFont(S - 2)
        } else {
            return UIFont.vodafoneRegularFont(S)
        }
    }

    /**
     This method provides bold Vodafone font with size small
     */
    @objc static func VFGSBold() -> UIFont? {
        return UIFont.vodafoneBoldFont(S)
    }

    /**
     This method provides light Vodafone font with size small
    */
    @objc static func VFGSLight() -> UIFont? {
        return UIFont.vodafoneLiteRegularFont(S)
    }

    /**
     This method provides regular Vodafone font.
     - parameter fontSize: requested font size
     - returns: Customized Vodafone regular UIFont object
     */
    @objc static func vodafoneRegularFont(_ fontSize: CGFloat) -> UIFont? {
        var result = UIFont(name: regularFontName, size: fontSize)
        if result == nil {
            registerFont(regularFontFilename)
            result = UIFont(name: regularFontName, size: fontSize)
        }
        return result
    }

    /**
     This method provides regular lite Vodafone font.
     - parameter fontSize: requested font size
     - returns: Customized Vodafone lite regular UIFont object
     */
    @objc static func vodafoneLiteRegularFont(_ fontSize: CGFloat) -> UIFont? {
        var result = UIFont(name: regularLiteFontName, size: fontSize)
        if result == nil {
            registerFont(regularLiteFontFilename)
            result = UIFont(name: regularLiteFontName, size: fontSize)
        }
        return result
    }

    /**
     This method provides bold Vodafone font.
     - parameter fontSize: requested font size
     - returns: Customized Vodafone bold UIFont object
     */
    @objc static func vodafoneBoldFont(_ fontSize: CGFloat) -> UIFont? {
        var result = UIFont(name: boldFontName, size: fontSize)
        if result == nil {
            registerFont(boldFontFilename)
            result = UIFont(name: boldFontName, size: fontSize)
        }
        return result
    }

}
