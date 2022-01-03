//
//  UIButton+MVA10.swift
//  MyVodafone
//
//  Created by Mohamed Salah Younis on 6/10/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

public enum MVA10ButtonStyle {
    case primary
    case secondary
    case tertiary
    case dimmed
    case redLink
    case quarter
    case secondaryDark
    case tertiaryDark

    public enum Size {
        case small
        case medium
    }
}

extension MVA10ButtonStyle {
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return UIColor.VFGVodafoneRed
        case .secondary:
            return UIColor.VFGLinkAnthraciteText
        case .tertiary:
            return .clear
        case .dimmed:
            return UIColor.VFGVodafonePlatinum
        case .redLink:
            return .clear
        case .tertiaryDark:
            return .white
        case .quarter:
            return .white

        case .secondaryDark:
            return .white

        }
    }

    var textColor: UIColor {
        switch self {
        case .primary, .secondary, .dimmed, .quarter:
            return UIColor.VFGWhiteBackground
        case .tertiary:
            return UIColor.black
        case .redLink:
            return UIColor.VFGVodafoneRed
        case .secondaryDark, .tertiaryDark:
            return UIColor.black
        }
    }

    var borderColor: CGColor {
        switch self {
        case .primary, .secondary, .dimmed, .redLink, .quarter, .secondaryDark, .tertiaryDark:
            return UIColor.clear.cgColor
        case .tertiary:
            return UIColor.darkGray.cgColor
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .primary, .secondary, .dimmed, .redLink, .quarter, .secondaryDark, .tertiaryDark:
            return 0
        case .tertiary:
            return 1.0
        }
    }

    func titleFont(size: MVA10ButtonStyle.Size) -> UIFont {
        if size == .small {
            return UIFont.vodafoneBold(16.0)
        }
        switch self {
        case .primary, .secondary, .dimmed, .tertiary, .quarter, .secondaryDark, .tertiaryDark:
            return UIFont.vodafoneRegular(18.0)
        case .redLink:
            return UIFont.vodafoneRegular(16.0)
        }
    }
}

public extension UIButton {
    /// Applies selected MVA10 style to button with an specific corner radius
    ///
    /// - Parameters:
    ///   - button: Button to apply style
    ///   - style: MVA10 style
    ///   - radius: corner radius
    static func apply(to button: UIButton, mva10Style style: MVA10ButtonStyle, with radius: CGFloat = 6.0, size: MVA10ButtonStyle.Size = .medium) {
        button.layer.cornerRadius = radius
        button.layer.masksToBounds = true
        button.backgroundColor = style.backgroundColor
        button.layer.borderColor = style.borderColor
        button.layer.borderWidth = style.borderWidth
        button.setTitleColor(style.textColor, for: .normal)
        button.titleLabel?.font = style.titleFont(size: size)
    }
}
