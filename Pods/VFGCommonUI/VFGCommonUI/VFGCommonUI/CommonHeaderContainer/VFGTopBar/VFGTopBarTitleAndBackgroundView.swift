//
//  VFGCommonTopBarTitleAndBackgroundView.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 25/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGTopBarTitleAndBackgroundView: UIView {

    static private var titleFontSize: CGFloat {
        if UIScreen.isIpad {
            return 31
        }
        return 22
    }

    static private let titleLabelXPosition: CGFloat = 53.0
    static private let titleLabelHeight: CGFloat = 35.0
    public var titleFont: UIFont? {
        get {
            return self.titleLabel.font
        }
        set {
            self.titleLabel.font = newValue ?? UIFont.vodafoneRegularFont(VFGTopBarTitleAndBackgroundView.titleFontSize)
        }
    }
    public var titleColor: UIColor? {
        get {
            return self.titleLabel.textColor
        }
        set {
            self.titleLabel.textColor = newValue ?? UIColor.VFGTopBarTitleColor
        }
    }

    var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }

    private var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.font = UIFont.vodafoneRegularFont(VFGTopBarTitleAndBackgroundView.titleFontSize)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.VFGTopBarTitleColor
        addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTitleLabel()
    }

    private func layoutTitleLabel() {

        var frame: CGRect = CGRect(x: VFGTopBarTitleAndBackgroundView.titleLabelXPosition,
                                   y: 0.0,
                                   width: (self.bounds.width - 2*VFGTopBarTitleAndBackgroundView.titleLabelXPosition),
                                   height: VFGTopBarTitleAndBackgroundView.titleLabelHeight)
        frame.origin.y = (self.bounds.height - frame.size.height)/2
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.frame = frame
    }
}
