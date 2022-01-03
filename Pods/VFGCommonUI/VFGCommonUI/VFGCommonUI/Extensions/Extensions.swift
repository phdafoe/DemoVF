//
//  Extensions.swift
//  VFGCommonUI
//
//  Created by Ehab Alsharkawy on 7/24/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public extension UIView {

    @objc func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: nil)
    }

    @objc func addChatBorder(color: UIColor) {
        clipsToBounds = true
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }

    func constraint(withIdentifier identifier: String) -> NSLayoutConstraint? {
        constraints.filter { $0.identifier == identifier }.first
    }
}
