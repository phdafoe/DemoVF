//
//  VFGBadgeView.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 24/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Badge view
 */
@objc public class VFGBadgeView: UIView {

    static let fontSize: CGFloat = 13
    static let textColor: UIColor = UIColor.white
    static let textMargin: CGFloat = 4

    @objc public override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
        }
    }

    /**
     Text displayed on badge
     */
    @objc public var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.textLabel.text = newValue
            self.invalidateIntrinsicContentSize()
        }
    }

    /**
     Badge text colour
     */
    @objc public var textColor: UIColor {
        get {
            return self.textLabel.textColor
        }
        set {
            self.textLabel.textColor = newValue
        }
    }

    /**
     Badge text font
     */
    @objc public var font: UIFont {
        get {
            return self.textLabel.font
        }
        set {
            self.textLabel.font = newValue
        }
    }

    lazy var textLabel: UILabel = {
        let label = self.createTextLabel()
        self.addSubview(label)

        return label
    }()

    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTextLabel()
        self.layer.cornerRadius = self.textLabel.frame.height / 2
    }

    @objc public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.componentSize()
    }

    @objc public override var intrinsicContentSize: CGSize {
        return componentSize()
    }

    private func layoutTextLabel() {
        self.textLabel.frame = self.textLabelFrame()
    }

    private func textLabelFrame() -> CGRect {
        return self.bounds
    }

    private func createTextLabel() -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.vodafoneBoldFont(VFGBadgeView.fontSize)
        label.textColor = VFGBadgeView.textColor
        label.textAlignment = .center

        return label
    }

    private func componentSize() -> CGSize {
        let minimumSize: CGSize = minimumIntrinsicSize()
        let computedSize: CGSize = computedIntrinsicSize()

        if computedSize.width < minimumSize.width {
            return minimumSize
        } else {
            return computedSize
        }
    }

    private func computedIntrinsicSize() -> CGSize {
        return self.sizeOfLabel(withText: self.textLabel.text ?? "")
    }

    private func minimumIntrinsicSize() -> CGSize {
        let squareSide: CGFloat = self.sizeOfLabel(withText: "0").height
        return CGSize(width: squareSide, height: squareSide)
    }

    private func sizeOfLabel(withText text: String) -> CGSize {
        let label: UILabel = self.createTextLabel()
        label.text = text
        label.sizeToFit()

        var size: CGSize = label.bounds.size
        size.width += VFGBadgeView.textMargin
        size.height += VFGBadgeView.textMargin

        return size
    }

}
