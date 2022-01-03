//
//  VFGConfigurableAlertViewModel.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGConfigurableAlertViewModel: NSObject {

    /**
     A method that configures and returns an overlay configurable View

     - parameter title: the title text to view on the overlay
     - parameter header: the header paragraph of the view
     - parameter img: The image to show
     - parameter imgHeight: the desired image height
     - parameter imgWidth: the desired image width
     - parameter paragraph: the subparagraph to show below the image
     - parameter closeButtonCallback : the close button callback
     */
    let title: String
    let header: String
    let img: UIImage?
    let imgSize: CGSize
    let paragraph: String
    let closeButtonCallback: (() -> Void)?
    let shouldSendTags: Bool

    public init(title: String = "",
                header: String = "",
                img: UIImage? = nil,
                imgSize: CGSize = CGSize.zero,
                paragraph: String = "",
                closeButtonCallback: (() -> Void)? = nil,
                shouldSendTags: Bool = false) {
        self.title = title
        self.header = header
        self.img = img
        self.imgSize = imgSize
        self.paragraph = paragraph
        self.closeButtonCallback = closeButtonCallback
        self.shouldSendTags = shouldSendTags

    }
}
