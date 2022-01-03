//
//  VFGBadgeButton.swift
//  VFGCommonUI
//
//  Created by Kamil Sławiński on 13/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Extended UIButton with extra badge for displaying count or other pieces of information
 */
@objc open class VFGBadgeButton: UIButton {

    fileprivate lazy var badge: VFGBadgeView = {
        let badge: VFGBadgeView = self.createBadge()
        self.addSubview(badge)
        return badge
    }()

    /**
     Displayed badge string
     */
    @objc open var badgeString: String? {
        get {
            return self.badge.text
        }
        set {
            self.badge.text = newValue
            self.badge.isHidden = (newValue?.count ?? 0) == 0
            self.setNeedsLayout()
        }
    }

    /**
     Badge's background color
     */
    @objc open var badgeBackgroundColor: UIColor? {
        get {
            return self.badge.backgroundColor
        }
        set {
            self.badge.backgroundColor = newValue
        }
    }

    private func createBadge() -> VFGBadgeView {
        let badge: VFGBadgeView = VFGBadgeView()
        badge.isHidden = true
        badge.isUserInteractionEnabled = false
        badge.backgroundColor = UIColor.VFGPrimaryRed
        return badge
    }

    @objc open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutBadge()
    }

    private func layoutBadge() {
        self.badge.sizeToFit()
        var badgeFrame: CGRect = self.badge.bounds
        if VFGTopBar.isSideMenuBadgeOnLeft {
            badgeFrame.origin.x = 4
        } else {
            badgeFrame.origin.x = self.bounds.width - badgeFrame.width
        }
        badgeFrame.origin.y = 6//0

        self.badge.frame = badgeFrame
    }

}
