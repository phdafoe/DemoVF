//
//  NSMutableAttributedString+Attribute.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    func addAttribute(font: UIFont) {
        addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: NSRange(location: 0, length: length)
        )
    }

    func addAttribute(font: UIFont, to text: String) {
        guard !text.isBlank else { return }
        addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: (string as NSString).range(of: text)
        )
    }

    func addAttribute(textColor: UIColor) {
        addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: textColor,
            range: NSRange(location: 0, length: length)
        )
    }
}
