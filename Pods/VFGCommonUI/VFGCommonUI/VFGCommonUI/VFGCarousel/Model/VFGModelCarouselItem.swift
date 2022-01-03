//
//  VFGCarouselItem.swift
//  VFGCarousel
//
//  Created by Lukasz Lewinski on 20/03/2018.
//  Copyright © 2018 Lukasz Lewinski. All rights reserved.
//

import Foundation

@objc public class VFGModelCarouselItem: NSObject {
    public private(set) var index: Int?
    public private(set) var itemId: String?
    public private(set) var name: String?
    public private(set) var showSelectionIcon: Bool = true

    @objc public init(index: Int, itemId: String, name: String, showSelectionIcon: Bool = true) {
        self.index              = index
        self.itemId             = itemId
        self.name               = name
        self.showSelectionIcon  = showSelectionIcon
    }

}
