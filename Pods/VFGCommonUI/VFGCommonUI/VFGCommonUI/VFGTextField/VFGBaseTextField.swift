//
//  VFGBaseTextField.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc public class VFGBaseTextField: UITextField {

    // MARK: - Padding constants

    let fieldHeight: CGFloat = 46
    let imagePadding: CGFloat = 13
    let textPadding: CGFloat = 13

    /// The different images for the field rightview button
    public enum ButtonImage: String {
        case info
        case eye
        case eyeCrossed
        case downArrow = "chevron-down"
        case none
    }

    // MARK: - Class Properties

    let rightViewBtn = UIImageView(image: UIImage(named: "info"))
    var callBack: (() -> Void) = { VFGDebugLog("Right view button clicked") }
    var showImage: Bool = false {
        didSet {
            VFGDebugLog("Setting showImage on VFGBaseTextField to \(showImage)")
            if showImage {
                self.rightViewMode = .always
                self.rightView = rightViewBtn
            } else {
                self.rightViewMode = .never
                self.rightView = nil
            }
        }
    }

    // MARK: - Class Initialization

    /// Used by storyboard to layout the view
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /// Used by the OS to initialize the view from a storyboard
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    /// Sets up the view with the the looks and functionality of the rightview image
    func setupView() {
        // Adding the rightView button to the textfield and setting its callback
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonCallBack))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rightViewBtn.isUserInteractionEnabled = true
        rightViewBtn.addGestureRecognizer(tapGestureRecognizer)
        rightViewBtn.contentMode = .center
        if showImage {
            self.rightViewMode = .always
            self.rightView = rightViewBtn
        }

        // Customizing the View
        adjustsFontSizeToFitWidth = false
        self.frame = CGRect(x: frame.origin.x,
                            y: frame.origin.y,
                            width: frame.width,
                            height: fieldHeight)
        self.applyStyle(VFGTextFieldStyle.basic)
    }

    // MARK: - Class Customization methods

    /// Use to setup the textfield with the given image and callback
    public func setupTextField(image: ButtonImage, buttonCallBack: (() -> Void)?) {
        switch image {
        case .none:
            showImage = false
        default:
            if let icon: UIImage = UIImage(named: image.rawValue, in: Bundle.vfgCommonUI, compatibleWith: nil) {
                setupTextField(customImage: icon, buttonCallBack: buttonCallBack)
            }
        }
    }

    /// Uset to setup the textfield with custom image for the right view button and a callback
    @objc public func setupTextField(customImage: UIImage, buttonCallBack:  (() -> Void)?) {
        rightViewBtn.image = customImage
        if let callBack = buttonCallBack {
            self.callBack = callBack
        }
        showImage = true
    }

    /// Use to disable the field and apply the disabled style
    @objc public func disableField() {
        VFGDebugLog("Applying VFGBaseTextField disabled style.")
        self.applyStyle(VFGTextFieldStyle.disabled)
        self.isEnabled = false
        self.rightViewBtn.tintColor = UIColor.cyan
    }

    /// Use to enable the field and apply the basic style
    @objc public func enableField() {
        VFGDebugLog("Applying VFGBaseTextField basic style.")
        self.applyStyle(VFGTextFieldStyle.basic)
        self.isEnabled = true
    }

    // MARK: - Overriding rectForBound methods to apply padding

    func getFrame(bounds: CGRect) -> CGRect {
        if let rightViewWidth = self.rightView?.bounds.width {
            return CGRect(x: bounds.origin.x + textPadding,
                          y: bounds.origin.y,
                          width: bounds.width - (rightViewWidth + textPadding + imagePadding ),
                          height: bounds.height)
        } else if self.clearButtonMode != .never {
            let clearButtonRect = self.clearButtonRect(forBounds: bounds)
            return CGRect(x: bounds.origin.x + textPadding,
                          y: bounds.origin.y,
                          width: bounds.width - ( textPadding + imagePadding + clearButtonRect.size.width ),
                          height: bounds.height)

        } else {
            return CGRect(x: bounds.origin.x + textPadding,
                          y: bounds.origin.y,
                          width: bounds.width - textPadding ,
                          height: bounds.height)
        }
    }

    @objc public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return getFrame(bounds: bounds)
    }

    @objc public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getFrame(bounds: bounds)
    }

    @objc public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return getFrame(bounds: bounds)
    }

    @objc public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightView: UIView = self.rightView else {
            VFGErrorLog("Cannot unwrap rightView. Returning empty CGRect")
            return CGRect()
        }
        let rect = CGRect(x: bounds.width - ((rightView.frame.width) + imagePadding),
                          y: (bounds.height - (rightView.frame.height))/2,
                          width: rightView.frame.size.width,
                          height: rightView.frame.size.height)
        return rect
    }

    // MARK: - Helper Methods

    /// An enclosing method for the callback of the right view button click
    @objc private func buttonCallBack() {
        self.callBack()
    }
}
