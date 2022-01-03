//
//  VFGSideMenuAbstractModel.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 14/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public protocol VFGSideMenuAbstractModel {

    func numberOfItems() -> Int
    func collapseAll()
    func badgeTextForItem(_ item: VFGSideMenuItem) -> String?
    func setBadgeText(_ text: String?, forItem item: VFGSideMenuItem)

    @available(*, deprecated, message: "since VFGCommonUI 2.5.0 use item(at index: Int) instead")
    func item(atRow row: Int) -> VFGSideMenuItem?

    @available(*, deprecated, message: "since VFGCommonUI 2.5.0 use index(forItem item: VFGSideMenuItem?) instead")
    func row(forItem item: VFGSideMenuItem?) -> Int

    @available(*, deprecated, message: "since VFGCommonUI 2.5.0 use isExpanded(at index: Int) instead")
    func isExpanded(atRow row: Int) -> Bool

    @available(*, deprecated, message: "since VFGCommonUI 2.5.0 use isExpandable(at index: Int) instead")
    func isExpandable(atRow row: Int) -> Bool

    @available(*, deprecated,
    message: "since VFGCommonUI 2.5.0 use expandItem(at index: Int, hasSeparator separator: Bool?) instead")
    func expandItem(atRow row: Int, hasSeparator separator: Bool?) -> Int

    @available(*, deprecated,
    message: "since VFGCommonUI 2.5.0 use collapseItem(at index: Int, hasSeparator separator: Bool?) instead")
    func collapseItem(atRow row: Int, hasSeparator separator: Bool?) -> Int

    @available(*, deprecated, message: "since VFGCommonUI 2.5.0")
    func is1stLevelItem(atRow row: Int) -> Bool

    func item(at index: Int) -> VFGSideMenuItem?
    func index(forItem item: VFGSideMenuItem?) -> Int
    func isExpanded(at index: Int) -> Bool
    func isExpandable(at index: Int) -> Bool
    func expandItem(at index: Int, hasSeparator separator: Bool?)
    func collapseItem(at index: Int, hasSeparator separator: Bool?)
    func updateVisibility(at index: Int, visible: Bool)
}

public extension VFGSideMenuAbstractModel {

    func item(atRow row: Int) -> VFGSideMenuItem? {
        return item(at: row)
    }

    func row(forItem item: VFGSideMenuItem?) -> Int {
        return index(forItem: item)
    }

    func isExpanded(atRow row: Int) -> Bool {
        return isExpanded(at: row)
    }

    func isExpandable(atRow row: Int) -> Bool {
        return isExpandable(at: row)
    }

    func expandItem(atRow row: Int, hasSeparator separator: Bool?) -> Int {
        expandItem(at: row, hasSeparator: separator)
        return item(at: row)?.subitems.count ?? 0
    }

    func collapseItem(atRow row: Int, hasSeparator separator: Bool?) -> Int {
        collapseItem(at: row, hasSeparator: separator)
        return item(at: row)?.subitems.count ?? 0
    }

    func is1stLevelItem(atRow row: Int) -> Bool {
        return true
    }
}
