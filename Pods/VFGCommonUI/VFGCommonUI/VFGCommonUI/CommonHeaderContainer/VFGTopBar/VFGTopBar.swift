//
//  VFGTopBarCommonView.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 24/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Top bar visible at top of the screen. Contains two buttons, left and right, and title.
 */
public class VFGTopBar: UIView {

    /**
     Height of top bar.
     */
    @objc  static public let topBarHeight: CGFloat = 54
    static private let horizontalMargin: CGFloat = 6
    static let backIconImageName: String = "arrowLeft01"
    static let menuIconImageName: String = "menu01"
    public static var isSideMenuBadgeOnLeft = true
    @objc public internal(set) var leftButton: UIButton!
    @objc public internal(set) var rightButton: VFGBadgeButton!

    @objc func onHamburgerBadgeReshresh(notification: NSNotification) {
        self.rightButton.badgeString = notification.userInfo?[VFGResponsiveUI.badgeStringKey] as? String ?? ""
    }

    /**

    topBar left icon image, optional property
     that if not setted the topbar will use the default
     leftIcon image inside commonUI component.
     */
    @objc public var leftButtonIconColor: UIColor? {
        get {
            return self.leftButton.tintColor
        }
        set {
            if newValue != nil {
                self.leftButton.tintColor = newValue
            }
        }
    }

    /**

    topBar right icon image, optional property that
     if not setted the topbar will use the default right
     image inside commonUI component.
    */
    @objc public var rightButtonIconColor: UIColor? {
        get {
            return self.rightButton.tintColor
        }
        set {
            if newValue != nil {
                self.rightButton.tintColor = newValue
            }
        }
    }

    /**
     Title displayed when top bar is not transparent
     */
    @objc public var title: String? {
        get {
            return self.titleAndBackground.title
        }
        set {
            self.titleAndBackground.title = newValue
        }
    }

    /**
     Background color for not transparent top bar
     */
    @objc public var opaqueBackgroundColor: UIColor? {
        get {
            return self.titleAndBackground.backgroundColor
        }
        set {
            self.titleAndBackground.backgroundColor = newValue ?? .black
        }
    }

    /**
     Alpha value of top bar header and background
     */
    @objc public var opaqueBackgroundAlpha: CGFloat {
        get {
            return self.titleAndBackground.alpha
        }
        set {
            self.titleAndBackground.alpha = parallaxEffectEnabled ? newValue : 1
            if VFGRootViewController.shared.nudgeView.isHidden == false {
                VFGRootViewController.shared.nudgeView.layer.zPosition = 100.0
            } else {
                 VFGRootViewController.shared.nudgeView.layer.zPosition = 0.0
            }
        }
    }

    @objc public var titleFont: UIFont? {
        get {
            return self.titleAndBackground.titleFont
        }
        set {
            self.titleAndBackground.titleFont = newValue
        }
    }

    @objc public var titleColor: UIColor? {
        get {
            return self.titleAndBackground.titleColor
        }
        set {
            self.titleAndBackground.titleColor = newValue
        }
    }

    /**
     disable or enable Parrallax effect
     */
    @objc public var parallaxEffectEnabled: Bool = true
    private var titleAndBackground: VFGTopBarTitleAndBackgroundView!

    /**
     Standard initialiser as in UIView
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VFGTopBar.onHamburgerBadgeReshresh),
                                               name: VFGResponsiveUI.onBadgeReshreshNotification,
                                               object: nil)
    }

    /**
     Standard initialiser as in UIView
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VFGTopBar.onHamburgerBadgeReshresh),
                                               name: VFGResponsiveUI.onBadgeReshreshNotification,
                                               object: nil)
    }

    private func setupView() {
        self.setupBarBackground()
        self.setupBarButtons()
    }

    private func setupBarBackground() {
        let barBackground: VFGTopBarTitleAndBackgroundView = VFGTopBarTitleAndBackgroundView(frame: self.bounds)
        barBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        barBackground.backgroundColor = UIColor.VFGTopBarBackgroundColor
        self.addSubview(barBackground)
        self.titleAndBackground = barBackground
        self.titleAndBackground.alpha = 0
    }

    private func setupBarButtons() {
        leftButton = buttonWith(named: VFGTopBar.backIconImageName)
        addSubview(leftButton)

        guard let badgeButton: VFGBadgeButton = buttonWith(named: VFGTopBar.menuIconImageName,
                                                                objClass: VFGBadgeButton.self) as? VFGBadgeButton else {
            VFGErrorLog("Cannot cast data to VFGBadgeButton")
            return
        }

        rightButton = badgeButton
        addSubview(rightButton)
    }

    private func buttonWith(tintColor: UIColor? = .white,
                            named: String,
                            bundle: Bundle = Bundle.vfgCommonUI,
                            objClass: UIButton.Type = UIButton.self)
        -> UIButton {
        let image: UIImage? = UIImage(named: named, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        let button: UIButton = objClass.init(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = tintColor
        button.frame = CGRect(x: 0, y: 0, width: VFGTopBar.topBarHeight, height: VFGTopBar.topBarHeight)
        return button
    }

    @objc public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: VFGTopBar.topBarHeight)
    }

    /**
     Standard layoutSubviews
     */
    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutLeftItem()
        self.layoutRightItem()
    }

    private func layoutLeftItem() {
        var frame: CGRect = self.leftButton.bounds
        frame.origin.x = VFGTopBar.horizontalMargin
        frame.origin.y = self.bounds.size.height/2 - frame.size.height/2 + 2
        self.leftButton.frame = frame
    }

    private func layoutRightItem() {
        var frame: CGRect = self.rightButton.bounds
        frame.origin.x = self.bounds.size.width - VFGTopBar.horizontalMargin - frame.size.width
        frame.origin.y = self.bounds.size.height/2 - frame.size.height/2 + 2
        self.rightButton.frame = frame
    }

}
