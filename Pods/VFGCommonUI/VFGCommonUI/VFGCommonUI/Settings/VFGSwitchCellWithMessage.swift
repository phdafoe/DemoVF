//
//  VFGSwitchCellWithMessage.swift
//  VFGCommonUI
//
//  Created by mohamed matloub on 2/1/18.
//

import Foundation
import UIKit

@objc public class VFGSwitchCellWithMessage: UITableViewCell {

    private var isChecked: Bool = false
    @objc public var onToggleActionComplete: ((_ isChecked: Bool) -> Void)?

    @IBOutlet weak private var viewContent: UIView!
    @IBOutlet weak private var customCellTitleLabel: UILabel!
    @IBOutlet weak private var switchButton: UISwitch!
    @IBOutlet weak private var customCellMessageLabel: UILabel!
    @IBOutlet weak private var messageView: UIView!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!

    private var cellTitle: String? {
        didSet {
            customCellTitleLabel.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellTitleLabel.text = cellTitle
        }
    }

    @objc public var cellMessage: String? {
        didSet {
            self.setupMessage()
        }
    }

    private var toggleOn: Bool = false {
        didSet {
            self.layoutSubviews()
            switchButton.isOn = toggleOn
            isChecked = toggleOn
        }
    }
    private var switchPreviousState: Bool = {
        return false
    }()

    @IBAction func switchValueDidChange() {
        if switchPreviousState != switchButton.isOn {
            switchPreviousState = switchButton.isOn
            self.onToggleActionComplete?(switchButton.isOn)
        }
    }

    @objc public func setup(title: String, isSwitchOn: Bool) {
        self.cellTitle = title
        self.toggleOn = isSwitchOn
        switchPreviousState = isSwitchOn
    }

    @objc public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchButton.backgroundColor = UIColor.buttonBackground
        switchButton.onTintColor = UIColor.buttonTint
        switchButton.layer.cornerRadius = 16.0
        switchButton.isOn = false
        switchPreviousState = false
        self.selectionStyle = .none
    }

    private func setupMessage() {
        guard let message = self.cellMessage, message.isEmpty == false else {
            self.hideMessageView()
            return
        }
        self.showMessageView(with: message)
    }

    func showMessageView(with message: String) {
        self.customCellMessageLabel.text = message
        self.messageView.isHidden = false
        self.messageViewHeightConstraint.constant = self.calculateMessageViewHeight(with: message)
        self.layoutSubviews()

        self.layoutIfNeeded()
    }
    private func hideMessageView() {
        self.customCellMessageLabel.text = ""
        self.messageView.isHidden = true
        self.messageViewHeightConstraint.constant = 17
        self.layoutSubviews()
        self.layoutIfNeeded()
    }

    private func calculateMessageViewHeight(with message: String) -> CGFloat {
        customCellMessageLabel.sizeToFit()
        let labelHeight = customCellMessageLabel.frame.size.height
        let margins: CGFloat = 64
        let iconHeight: CGFloat = 26
        let height = labelHeight > iconHeight ? labelHeight : iconHeight
        return height.advanced(by: margins)
    }
}
