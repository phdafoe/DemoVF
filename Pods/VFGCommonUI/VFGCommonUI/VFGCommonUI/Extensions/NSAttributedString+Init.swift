//
//  NSAttributedString+Init.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import VFGCommonUtils

extension NSAttributedString {
    convenience init?(with firstMessage: String, and secondMessage: String) {
        let ipadFirstMessageFontSize: CGFloat =  30
        let ipadSecondMessageFontSize: CGFloat = 24
        let iphoneFirstMessageFontSize: CGFloat = 20
        let iphoneSecondMessageFontSize: CGFloat = 16

        let firstMessageFontSize: CGFloat
        let secondMessageFontSize: CGFloat

        let paragraphStyle = NSMutableParagraphStyle()
        let attrString: NSMutableAttributedString = NSMutableAttributedString()

        paragraphStyle.lineBreakMode = .byWordWrapping

        if UIScreen.isPhone {
            firstMessageFontSize = iphoneFirstMessageFontSize
            secondMessageFontSize = iphoneSecondMessageFontSize
        } else {
            firstMessageFontSize = ipadFirstMessageFontSize
            secondMessageFontSize = ipadSecondMessageFontSize
        }

        guard let vodafoneFirstRegularFont: UIFont = UIFont.vodafoneRegularFont(firstMessageFontSize) else {
            VFGErrorLog("Cannot unwrap first vodafoneRegularFont")
            return nil
        }
        let attributes = [NSAttributedString.Key.font: vodafoneFirstRegularFont,
                          NSAttributedString.Key.foregroundColor: UIColor.white]
        let firstAttrString: NSAttributedString = NSAttributedString(string: firstMessage,
                                                                     attributes: attributes)
        attrString.append(firstAttrString)

        guard let vodafoneSecondRegularFont: UIFont = UIFont.vodafoneRegularFont(secondMessageFontSize) else {
            VFGErrorLog("Cannot unwrap second vodafoneRegularFont")
            return nil
        }

        if !secondMessage.isEmpty {
            let attributes = [NSAttributedString.Key.font: vodafoneSecondRegularFont,
                              NSAttributedString.Key.foregroundColor: UIColor.white]
            let secondAttrString: NSAttributedString = NSAttributedString(string: "\n\n"+secondMessage,
                                                                          attributes: attributes)
            attrString.append(secondAttrString)
        }
        self.init(attributedString: attrString)
    }
}
