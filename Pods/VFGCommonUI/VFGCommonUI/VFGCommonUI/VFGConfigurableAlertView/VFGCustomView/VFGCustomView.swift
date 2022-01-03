//
//  VFGCustomView.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/27/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class VFGCustomView: UIView, SizeableView {

    static let nibFileName = "alertCustomView"

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var paragraph: UILabel!
    @IBOutlet weak var imgTop: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var paragraphTop: NSLayoutConstraint!
    @IBOutlet weak var imgToView: NSLayoutConstraint!

    func setUpView(header: String?, paragraph: String?, img: UIImage?, imgHeight: Float, imgWidth: Float) {

        // Setting up header
        if let textHeader = header {
            self.header.text = textHeader
            imgToView.constant = 0
            imgToView.priority = UILayoutPriority.defaultLow
        } else {
            self.header.isHidden = true
            imgTop.constant = 0
            imgToView.constant = 0
            imgTop.priority = UILayoutPriority.defaultLow
            imgToView.priority = UILayoutPriority.required
        }
        // Setting up image
        if let customImg = img {
            self.image.image = customImg
            self.imgHeight.constant = CGFloat(imgHeight)
            self.imgWidth.constant = CGFloat(imgWidth)
        } else {
            self.imgHeight.constant = 0
            self.image.isHidden = true
            imgTop.constant = 0
        }
        // Setting up paragraph
        if let paragraphText = paragraph {
            self.paragraph.text = paragraphText
            if self.header.isHidden && self.image.isHidden {
                self.paragraphTop.constant = 0
            }
        } else {
            self.paragraph.isHidden = true
        }

        applyStyles()
    }

    private func applyStyles() {
        if image.isHidden {
            header.textAlignment = .left
            header.applyStyle(VFGTextStyle.paragraphTitleColored(UIColor.VFGWhite))
            paragraph.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGWhite))
        } else {
            header.textAlignment = .center
            header.applyStyle(VFGTextStyle.headerColored(UIColor.VFGWhite))
            paragraph.applyStyle(VFGTextStyle.paragraphTitleColored(UIColor.VFGWhite))
        }
    }

    func getViewHeight() -> CGFloat {
        header.sizeToFit()
        paragraph.sizeToFit()
        self.layoutIfNeeded()
        var height: CGFloat = 0
        if !header.isHidden {height += header.frame.height}
        if !paragraph.isHidden {height += paragraph.frame.height}
        height += imgHeight.constant
        height += imgTop.constant
        height += paragraphTop.constant
        return height
    }

    class func fromNib() -> VFGCustomView? {
        return Bundle.vfgCommonUI.loadNibNamed(nibFileName, owner: nil, options: nil)?.first as? VFGCustomView
    }

}
