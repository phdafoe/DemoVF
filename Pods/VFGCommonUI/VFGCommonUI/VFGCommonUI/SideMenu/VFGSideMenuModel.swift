//
//  VFGSideMenuModel.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 13/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

public enum ItemAction {
    case collapse
    case expand
}

class VFGSideMenuModel: NSObject, VFGSideMenuAbstractModel {

    let items: [VFGSideMenuItem]

    var expandedItem: Int?
    var badgeTextForItem : [ VFGSideMenuItem: String ] = [:]

    init(items: [VFGSideMenuItem]) {
        self.items = items
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func collapseAll() {
        if let expandedItem = expandedItem, let item = item(at: expandedItem), let lastSubItem = item.subitems.last {
            handleSeparatorForAction(action: .collapse, atSection: expandedItem, hasSeparator: lastSubItem.separator)
        }
        expandedItem = nil
    }

    func badgeTextForItem(_ item: VFGSideMenuItem) -> String? {
        return badgeTextForItem[item]
    }

    func setBadgeText(_ text: String?, forItem item: VFGSideMenuItem) {
        badgeTextForItem[item] = text
    }

    func item(at index: Int) -> VFGSideMenuItem? {
        if items.count > index {
            return items[index]
        }
        return nil
    }

    func index(forItem item: VFGSideMenuItem?) -> Int {
        guard let item = item,
            let index = items.firstIndex(of: item) else { return NSNotFound }
        return index
    }

    func isExpanded(at index: Int) -> Bool {
        return expandedItem == index
    }

    func isExpandable(at index: Int) -> Bool {
        return item(at: index)?.isExpandable ?? false
    }

    func expandItem(at index: Int, hasSeparator separator: Bool?) {
        if !items[index].isExpandable {
            return
        }
        handleSeparatorForAction(action: .expand, atSection: index, hasSeparator: item(at: index)?.separator)
        expandedItem = index
    }

    func collapseItem(at index: Int, hasSeparator separator: Bool?) {
        let index: Int = index
        if index == NSNotFound || !items[index].isExpandable {
            return
        }

        let itemsCount: Int = items[index].subitemsCount()
        handleSeparatorForAction(action: .collapse,
                                 atSection: index,
                                 hasSeparator: item(at: index)?.subitems[itemsCount - 1].separator)

        if expandedItem == index {
            expandedItem = nil
        }
    }

    func updateVisibility(at index: Int, visible: Bool) {
        items[index].visible = visible
    }

    private func handleSeparatorForAction(action: ItemAction, atSection section: Int, hasSeparator separator: Bool?) {
        let index: Int = section

        if let separator = separator {
            if separator {
                let itemToHasSeparator = items[index].subitems.last
                switch action {
                case .expand:
                    items[index].separator = false
                    itemToHasSeparator?.separator = true
                case .collapse:
                    items[index].separator = true
                    itemToHasSeparator?.separator = false
                }
            }
        }

    }

}
