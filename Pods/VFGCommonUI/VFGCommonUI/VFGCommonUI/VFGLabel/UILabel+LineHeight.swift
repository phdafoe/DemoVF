//
//  UILabel+LineHeight.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

extension UILabel {

    /**
     Change the lineheight of the text in UILabel
     
     - Parameter lineHeight: CGFloat expressing the desired lineheight.
     */
    @objc public func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()

            style.lineSpacing = lineHeight
            attributeString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key,
                                         value: style, range: NSRange(location: 0, length: attributeString.length))
            attributedText = attributeString
        }
    }
}
