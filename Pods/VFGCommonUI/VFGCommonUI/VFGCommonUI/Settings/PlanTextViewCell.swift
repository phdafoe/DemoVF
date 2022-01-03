//
//  PlanTextViewCell.swift
//  Pods
//
//  Created by Ahmed Askar on 8/27/17.
//
//

import UIKit

@objc public class PlanTextViewCell: UITableViewCell {

    @IBOutlet weak private var customCellTitle: UILabel!
    @IBOutlet weak var customCellSeeMoreText: UILabel!
    @IBOutlet weak var cutomCellLinkButton: UIButton!
    /** Property to set cell title */
    @objc public var cellTitle: String? {
        didSet {
            customCellTitle.text = cellTitle
            customCellTitle.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
        }
    }

    //seeMoreText property
    @objc public var cellSeeMoreText: NSAttributedString? {
        didSet {
            customCellSeeMoreText.attributedText = cellSeeMoreText
            customCellSeeMoreText.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellSeeMoreText.adjustsFontSizeToFitWidth = true
//            customCellSeeMoreText.sizeToFit()
             customCellSeeMoreText.isHidden = false
        }
    }
    //seeMoreText property
    @objc public var cellLinkTitle: String? {
        didSet {
            cutomCellLinkButton.setTitle(cellLinkTitle, for: .normal)
            // underline
            let underlineAttribute = [kCTUnderlineStyleAttributeName as NSAttributedString.Key:
                                      NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: cutomCellLinkButton.titleLabel?.text ?? "",
                                                               attributes: underlineAttribute)
            cutomCellLinkButton.titleLabel?.attributedText = underlineAttributedString
            cutomCellLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
            cutomCellLinkButton.titleLabel?.sizeToFit()
            cutomCellLinkButton.sizeToFit()
        }
    }

    @objc public func getSeeMoreLabel() -> UILabel {
        return customCellSeeMoreText
    }

}
