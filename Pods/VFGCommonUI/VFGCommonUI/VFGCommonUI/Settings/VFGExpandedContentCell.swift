//
//  VFGExpandedContentCell.swift
//  TestProj
//
//  Created by Ahmed Askar on 8/9/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import UIKit

public class VFGExpandedContentCell: UITableViewCell {

    public var cardContents: [VFGPrivacyOptionsContentCard]?

    public var onExpandComplete: (() -> Void)?

    @IBOutlet weak private var stripViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak private var stripView: UIView!

    @IBOutlet weak private var viewContent: UIView!

    @IBOutlet weak private var customCellTitle: UILabel!

    @IBOutlet weak private var contentLabel: UILabel!

    @IBOutlet weak private var arrowImage: UIImageView!

    /** Property to set cell title */
    @objc public var cellTitle: String? {
        didSet {
            customCellTitle.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellTitle.text = cellTitle
        }
    }

    /** Property to set strip view color */
    @objc public var stripViewColor: UIColor? {
        didSet {
            stripView.backgroundColor = stripViewColor
        }
    }

    /** Property to assign strip view visibility */
    @objc public var stripViewHidden: Bool = false {
        didSet {
            if stripViewHidden == true {
                stripViewWidthConstraint.constant = 0
            } else {
                stripViewWidthConstraint.constant = 5
            }
            self.layoutIfNeeded()

        }
    }

    @objc public override func awakeFromNib() {
        self.selectionStyle = .none
        contentLabel.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
    }

    @objc public override func prepareForReuse() {
        super.prepareForReuse()
        contentAttributedString.setAttributedString(NSAttributedString(string: ""))
    }

    @objc public var isExpanded: Bool = false {
        didSet {
            var angle: CGFloat = 0.0
            if isExpanded {
                angle = CGFloat.pi
                if let cards = cardContents {
                    let resultAttributedString = getText(cardContents: cards)
                    contentLabel.attributedText = resultAttributedString
                }
            } else {
                angle = -Angle.doublePi
                contentLabel.text = ""
            }

            UIView.animate(withDuration: 0.3) {[weak self] in
                let transform = CGAffineTransform.identity.rotated(by: angle)
                self?.arrowImage.transform = transform
            }

        }
    }

    var contentAttributedString = NSMutableAttributedString()

    private func getText(cardContents: [VFGPrivacyOptionsContentCard]) -> NSMutableAttributedString {
        contentAttributedString.setAttributedString(NSAttributedString(string: ""))
        for item in cardContents {
            if contentAttributedString.length != 0 {
                contentAttributedString.append(NSAttributedString(string: ""))
                self.appendStringWithContentType(item: item)
            } else {
                self.appendStringWithContentType(item: item)
            }
        }
        return contentAttributedString
    }

    private func appendStringWithContentType(item: VFGPrivacyOptionsContentCard) {
        switch item.contentType {
        case .normal:
            guard let paragraphString = (item as? NormalParagraph)?.paragraph else {
                return
            }
            contentAttributedString.append(NSAttributedString(string: paragraphString))
            contentAttributedString.append(NSAttributedString(string: "\n"))
        case .bullets:
            guard let paragraphWithBullets = item as? ParagraphWithBullets else {
                return
            }
            contentAttributedString.append(NSAttributedString(string: paragraphWithBullets.paragraph))
            contentAttributedString.append(NSAttributedString(string: "\n\n"))

            for itemBullet in paragraphWithBullets.bullets {
                contentAttributedString.append(NSAttributedString(string: "• "))
                contentAttributedString.append(NSAttributedString(string: itemBullet))
                contentAttributedString.append(NSAttributedString(string: "\n\n"))
            }
        }
    }
}
