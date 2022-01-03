//
//  VFGPasswordTextField.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/10/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc public class VFGPasswordTextField: VFGBaseTextField {

    private let iconName: String = "eveicon"
    private let iconType: String = "png"
    @objc public var showPasswordAction : ((_ isSecure: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPasswordField()
    }

    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPasswordField()
    }

    /// convenience method to setup the password text field
    func setupPasswordField() {
        setupView()
        self.isSecureTextEntry = true
        self.font = UIFont.VFGM()
        setupTextField(image: .eye, buttonCallBack: toggleSecureText)
    }

    override  public func prepareForInterfaceBuilder() {
        setupView()

        // Viewing the image in the storyboard from the bundle
        let theBundle = Bundle(for: VFGBaseTextField.self)
        VFGDebugLog("Looking for image: " + iconName + " in bundle " + theBundle.debugDescription)
        guard let string: String = theBundle.path(forResource: iconName, ofType: iconType) else {
            VFGErrorLog("Cannot obtain path to resource:\(iconName).\(iconType)")
            return
        }

        if let image: UIImage = UIImage(contentsOfFile: string) {
            setupTextField(customImage: image, buttonCallBack: toggleSecureText)
        }
    }

    func toggleSecureText() {
        VFGDebugLog("Toggle secure text on VFGPasswordTextField. Value = " + String(isSecureTextEntry))
        self.font = UIFont.VFGM()
        if isSecureTextEntry {
            self.setupTextField(image: .eyeCrossed, buttonCallBack: toggleSecureText)
            self.isSecureTextEntry = false
        } else {
            self.setupTextField(image: .eye, buttonCallBack: toggleSecureText)
            self.isSecureTextEntry = true
        }
        self.showPasswordAction?(isSecureTextEntry)

        //fix issue when disable securemode cursor shift
        let str = self.text
        self.text = ""
        self.text = str
    }

}
