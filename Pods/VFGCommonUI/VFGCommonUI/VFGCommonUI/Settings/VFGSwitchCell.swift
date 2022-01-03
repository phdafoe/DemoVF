//
//  VFGSwitchCell.swift
//  VFGNetPerform
//
//  Created by Ahmed Askar on 8/26/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

@objc public class VFGSwitchCell: UITableViewCell {

    // MARK: - Properties
    private var isChecked: Bool = false
    private var useDefaultToggleDesign = true
    @objc public var onToggleActionComplete: ((_ isChecked: Bool) -> Void)?

    // MARK: - View Outlets
    @IBOutlet weak private var stripViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var stripView: UIView!
    @IBOutlet weak private var viewContent: UIView!
    @IBOutlet weak private var customCellTitle: UILabel!
    @IBOutlet weak private var switchBtn: UISwitch!

    /** Property to set cell title */
    private var cellTitle: String? {
        didSet {
            customCellTitle.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellTitle.text = cellTitle
        }
    }

    /** Property to set strip view color */
    private var stripViewColor: UIColor? {
        didSet {
            stripView.backgroundColor = stripViewColor
        }
    }

    /** Property to assign strip view visibility */
    private var stripViewHidden: Bool = false {
        didSet {
            if stripViewHidden == true {
                stripViewWidthConstraint.constant = 0
            } else {
                stripViewWidthConstraint.constant = 5
            }

            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    /** Property to assign strip view visibility */
    private var toggleOn: Bool = false {
        didSet {
            self.layoutSubviews()
            switchBtn.isOn = toggleOn
            isChecked = toggleOn
        }
    }
    private var switchPreviousState: Bool = {
        return false
    }()

    @IBAction func switchValueDidChange() {
        if switchPreviousState != switchBtn.isOn {
            switchPreviousState = switchBtn.isOn
            self.onToggleActionComplete?(switchBtn.isOn)
        }
    }

    @objc public func setup(title: String,
                            isStripViewHidden: Bool,
                            useNativeToggleDesign: Bool,
                            isSwitchOn: Bool) {
        useDefaultToggleDesign = false
        setup(title: title, isStripViewHidden: isStripViewHidden, isSwitchOn: isSwitchOn)
        if !useNativeToggleDesign {
            switchBtn.onTintColor = UIColor(red: 4/255, green: 123/255, blue: 147/255, alpha: 1)
        }
    }

    @objc public func setup(title: String,
                            isStripViewHidden: Bool,
                            isSwitchOn: Bool) {
        self.cellTitle = title
        self.stripViewHidden = isStripViewHidden
        self.toggleOn = isSwitchOn
        switchPreviousState = isSwitchOn
        if useDefaultToggleDesign {
            switchBtn.onTintColor = UIColor(red: 4/255, green: 123/255, blue: 147/255, alpha: 1)
        }
    }

    @objc public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchBtn.backgroundColor = UIColor.buttonBackground
        switchBtn.layer.cornerRadius = 16.0
        switchBtn.isOn = false
        switchPreviousState = false
        self.selectionStyle = .none
    }

    @objc public func switchUserInteractionStatus(isServiceEnabled: Bool) {
        if switchBtn != nil {
            switchBtn.isUserInteractionEnabled = isServiceEnabled
        }
    }
}
