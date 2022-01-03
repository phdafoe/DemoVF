//
//  VFGSideMenuItem.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 13/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

@objc public enum InfoImagePosition: Int {
    case leading
    case trailing
}

/**
 Represents item in menu.
 */
@objc public class VFGSideMenuItem: NSObject {

    private static let separatorHash: Int = 7
    private static let zeroHashValue: Int = 0

    /**
     Menu item id.
     */
    @objc public let itemId: Int

    /**
     Menu item title.
     */
    @objc public let title: String

    /**
     Menu item image.
     */
    @objc public let image: UIImage?

    /**
     Menu right item image.
     */
    @objc public var rightImage: UIImage?

    /**
     Sub menu items for this menu item.
     */
    @objc public let subitems: [VFGSideMenuItem]
    /**
     Should item contain separator at the bottom.
     */
    @objc public var separator: Bool

    /**
     Should the item be visible or not.
     */
    @objc public var visible: Bool

    /**
        parentItem if this item is child and have parent item,may be nil.
     */
    @objc public weak var parentItem: VFGSideMenuItem?

    /**
     is the item currently selected in the menu or not
     */
    @objc public var isItemSelected: Bool

    /**
     Informs whether this item can be expanded, true if it contains sub items.
     */
    var isExpandable: Bool {
        return subitems.count != 0
    }

    /**
     Menu info item image.
     */
    @objc public var infoImage: UIImage?

    /**
     Menu info item image position.
     */
    @objc public var infoImagePosition: InfoImagePosition = .leading

    /**
     Hash of the item. Function computes hash based on object title, image and presence of separator.
     Hash is computed by doing xor of hashes of given values.
     */
    override public var hash: Int {
        let imageHash = image?.hash ?? VFGSideMenuItem.zeroHashValue
        let separatorHash = separator ? VFGSideMenuItem.separatorHash : VFGSideMenuItem.zeroHashValue
        return title.hash ^ imageHash ^ separatorHash
    }

    /**
     Compare two menu items
     */
    override public func isEqual(_ object: Any?) -> Bool {
        guard let compared = object as? VFGSideMenuItem else {
            return false
        }
        return title == compared.title &&
            image == compared.image &&
            subitems == compared.subitems &&
            separator == compared.separator
    }

    /**
     Create menu item object.

     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)

     */
    @objc public init(itemId: Int,
                      title: String,
                      image: UIImage? = nil,
                      separator: Bool = false,
                      subitems: [VFGSideMenuItem] = []) {

        self.itemId = itemId
        self.title = title
        self.image = image
        self.subitems = subitems
        self.separator = separator
        self.visible = true
        self.isItemSelected = false
        super.init()
        subitems.forEach({$0.parentItem = self})
    }

    /**
     Create menu item object.

     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)
     - Parameter visible: True if element should be visible by default

     */
    @objc public convenience init(itemId: Int,
                                  title: String,
                                  image: UIImage? = nil,
                                  separator: Bool = false,
                                  subitems: [VFGSideMenuItem] = [],
                                  visible: Bool = false) {

        self.init(itemId: itemId, title: title, image: image, separator: separator, subitems: subitems)
        self.visible = visible
    }

    /**
     Create menu item object.
     
     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)
     - Parameter rightImage: Menu item image
     
     */
    @objc public convenience init(itemId: Int,
                                  title: String,
                                  image: UIImage? = nil,
                                  separator: Bool = false,
                                  subitems: [VFGSideMenuItem] = [],
                                  rightImage: UIImage? = nil) {

        self.init(itemId: itemId, title: title, image: image, separator: separator, subitems: subitems)
        self.rightImage = rightImage
    }

    /**
     Returns number of subitems in given menu item.
     */
    @objc public func subitemsCount() -> Int {
        return self.subitems.count
    }

}
