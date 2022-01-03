//
//  VFGSideMenuItemView.swift
//  VFGCommonUI
//
//  Created by Mohamed Matloub on 3/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGSideMenuItemView: UIView {

    @IBOutlet var contentView: UIView!
    @IBInspectable var nibName: String = "VFGSideMenuItemView"

    static let expandImage: String = "chevron-down"
    static let fontSize: CGFloat = 17
    static let iPadSize: CGFloat = 21

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var badge: VFGBadgeView!
    @IBOutlet weak var expandButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedCellWhiteView: UIView!

    @IBOutlet weak var infoImageView: UIImageView!
    var infoImageLeadingConstraint: NSLayoutConstraint!
    var infoImageTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var infoImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    var tapGesture: UITapGestureRecognizer!
    var tapAction: (() -> Void)?

    required override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Setup view from .xib file
        xibSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if isIPad() {
            titleLabel.font = UIFont.vodafoneRegularFont(VFGSideMenuItemView.iPadSize)
        } else {
            titleLabel.font = UIFont.vodafoneRegularFont(VFGSideMenuItemView.fontSize)
        }
        if UIScreen.IS_4_INCHES() {
            leftImageLeadingConstraint.constant = 25
        }
        separator.backgroundColor = UIColor.VFGMenuSeparator
        let expand: UIImage? = UIImage(fromCommonUINamed:
            VFGSideMenuItemView.expandImage)?.withRenderingMode(.alwaysTemplate)
        let collapse: UIImage? = expand?.mirroredDown
        expandButton.imageView?.tintColor = UIColor.white
        expandButton.setImage(expand, for: .normal)
        expandButton.setImage(collapse, for: .selected)
        expandButton.setImage(collapse, for: [.selected, .highlighted])
        expandButton.sizeToFit()
        badge.backgroundColor = UIColor.VFGPrimaryRed

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHeader(gestureRecognizer:)))
        addGestureRecognizer(tapGesture)
    }

    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        tapAction?()
    }

    func removeGesture() {
        if let tapGesture = tapGesture {
            removeGestureRecognizer(tapGesture)
        }
    }

    func setExpanded(expanded: Bool) {
        expandButton?.isSelected = expanded
    }

    fileprivate func setupLeadingInfoImage() {
        infoImageLeadingConstraint?.isActive = false
        infoImageTrailingConstraint?.isActive = false
        infoImageLeadingConstraint = NSLayoutConstraint(item: infoImageView,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        toItem: titleLabel,
                                                        attribute: .trailing,
                                                        constant: 10)
        if expandButtonWidthConstraint.constant == 0 {
            infoImageTrailingConstraint = NSLayoutConstraint(item: infoImageView,
                                                             attribute: NSLayoutConstraint.Attribute.trailing,
                                                             relatedBy: .lessThanOrEqual,
                                                             toItem: self,
                                                             attribute: .trailing,
                                                             multiplier: 1.0,
                                                             constant: -10)

        } else {
            infoImageTrailingConstraint = NSLayoutConstraint(item: infoImageView,
                                                             attribute: NSLayoutConstraint.Attribute.trailing,
                                                             relatedBy: .lessThanOrEqual,
                                                             toItem: expandButton,
                                                             attribute: .leading,
                                                             multiplier: 1.0,
                                                             constant: -10)
        }
        infoImageLeadingConstraint.isActive = true
        infoImageTrailingConstraint.isActive = true
    }

    fileprivate func setupTraillingInfoImage() {
        infoImageLeadingConstraint?.isActive = false
        infoImageTrailingConstraint?.isActive = false
        infoImageLeadingConstraint = NSLayoutConstraint(item: infoImageView,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        relatedBy: .greaterThanOrEqual,
                                                        toItem: titleLabel,
                                                        attribute: .trailing,
                                                        multiplier: 1.0,
                                                        constant: 10)
        if expandButtonWidthConstraint.constant == 0 {
            infoImageTrailingConstraint = NSLayoutConstraint(item: infoImageView,
                                                             attribute: NSLayoutConstraint.Attribute.trailing,
                                                             toItem: self,
                                                             attribute: .trailing,
                                                             constant: -10)
        } else {
            infoImageTrailingConstraint = NSLayoutConstraint(item: infoImageView,
                                                             attribute: NSLayoutConstraint.Attribute.trailing,
                                                             toItem: expandButton,
                                                             attribute: .leading,
                                                             constant: -10)
        }
        infoImageLeadingConstraint.isActive = true
        infoImageTrailingConstraint.isActive = true
    }

    func setupInfoImageConstraints(position: InfoImagePosition) {
        infoImageLeadingConstraint?.isActive = false
        infoImageTrailingConstraint?.isActive = false

        if position == .leading {
            setupLeadingInfoImage()
        } else {
            setupTraillingInfoImage()
        }
        infoImageLeadingConstraint?.isActive = true
        infoImageTrailingConstraint?.isActive = true
    }

    func setInfoImage(image: UIImage?, position: InfoImagePosition) {
        if let infoImage = image {
            infoImageHeightConstraint.constant = 15

            // update hidden states
            rightImage.isHidden = true
            infoImageView.isHidden = false
            //setup info image
            infoImageView.image = infoImage
            setupInfoImageConstraints(position: position)

        } else {
            // update hidden states
            rightImage.isHidden = false
            infoImageHeightConstraint.constant = 0
            infoImageView.isHidden = true
        }
    }

    deinit {
        removeGesture()
    }

}

// MARK: Section Xib Setup
extension VFGSideMenuItemView {

    func xibSetup() {
        removeSubViews()
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: Bundle.vfgCommonUI)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func removeSubViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
