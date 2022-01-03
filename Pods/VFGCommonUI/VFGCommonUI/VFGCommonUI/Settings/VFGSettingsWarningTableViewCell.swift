//
//  VFGSettingsWarningTableViewCell.swift
//  VFGNetPerform
//
//  Created by Ehab on 12/4/17.
//

import UIKit

@objc public class VFGSettingsWarningTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!

    @objc public func setup(message: String) {
        messageLabel.text = message
    }
    @objc public func changeDownArrowStatus(shouldHide: Bool) {
        if downArrowImageView != nil {
            downArrowImageView.isHidden = shouldHide
        }
    }

}
