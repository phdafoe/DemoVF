//
//  UIButton+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by kasa on 15/03/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

extension UIButton {

    func setPrimaryStyle() {
        self.titleLabel?.font = UIFont.vodafoneRegularFont(18)
        self.titleLabel?.textColor = UIColor.white
        self.setBackgroundColor(color: UIColor.VFGOverlayDefaultRed, for: .normal)
        self.setBackgroundColor(color: UIColor.VFGOverlayOnTapRed, for: .highlighted)
        self.setBackgroundColor(color: UIColor.VFGOverlayDisabledGrey, for: .disabled)
    }

    func setSecondaryStyle() {
        self.titleLabel?.font = UIFont.vodafoneRegularFont(18)
        self.titleLabel?.textColor = UIColor.clear
        self.setBackgroundColor(color: UIColor.VFGOverlayDefaultSecondaryGray, for: .normal)
        self.setBackgroundColor(color: UIColor.VFGOverlayOnTapSecondaryGray, for: .highlighted)
        self.setBackgroundColor(color: UIColor.VFGOverlayDisabledGrey, for: .disabled)
    }

    func setTertiaryStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.titleLabel?.font = UIFont.vodafoneRegularFont(18)
        self.titleLabel?.textColor = UIColor.white
        self.setBackgroundColor(color: UIColor.VFGOverlayDefaultTertiaryGray, for: .normal)
        self.setBackgroundColor(color: UIColor.VFGOverlayOnTapTertiaryGray, for: .highlighted)
        self.setBackgroundColor(color: UIColor.VFGOverlayDisabledGrey, for: .disabled)
    }

    func setBackgroundColor(color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: state)
    }

}
