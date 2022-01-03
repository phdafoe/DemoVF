//
//  VFGSideMenuTableController.swift
//  VFGCommonUI
//  Created by Michał Kłoczko on 14/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGSideMenuTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {

    static let cellIdentifier: String = "SideMenuCell"
    static let headerIdentifier = "tableSectionHeader"
    static let rowHeightProportion: CGFloat = 52.0/740.0
    static let expandButtonWidth: CGFloat = isIPad() ? 16.0 : 22.0
    static let rowHeight: CGFloat = ceil(max(VFGCommonUISizes.minClickableAreaSize,
                                             rowHeightProportion * UIScreen.main.bounds.size.height))

    let sharedRootVC = VFGRootViewController.shared
    private var isExpanding = false

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section =  model?.item(at: section),
            section.visible == true else { return 0 }
        return VFGSideMenuTableModel.rowHeight
    }

    var tableView: UITableView? {
        didSet {
            tableView?.rowHeight = VFGSideMenuTableModel.rowHeight
            tableView?.delegate = self
            tableView?.dataSource = self
            let headerView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: tableView?.frame.width ?? 0,
                                                  height: 40))
            tableView?.tableHeaderView = headerView

            let nib = UINib(nibName: "VFGSideMenuTableViewHeader", bundle: Bundle.vfgCommonUI)
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: "tableSectionHeader")
        }
    }
    var model: VFGSideMenuAbstractModel? {
        didSet {
            tableView?.reloadData()
        }
    }

    var sideMenuCellColor = UIColor.VFGTopBarTitleColor
    var itemAtRowClickedCallback : ((_ row: Int, _ item: VFGSideMenuItem) -> Void)?

    func collapseAll() {
        model?.collapseAll()
        lastExpandedSection = nil
        tableView?.reloadData()
    }

    internal var lastSelectedItem: VFGSideMenuItem?
    internal weak var currentViewController: UIViewController?
    internal var nextItem: VFGSideMenuItem?

    var lastExpandedSection: Int?

    func updateCell(at index: Int) {

        guard let header = tableView?.headerView(forSection: index) as? VFGSideMenuTableViewHeader else {
            VFGDebugLog("Skipping updateCell for section:\(index)")
            return
        }
        guard let item: VFGSideMenuItem = model?.item(at: index) else {
            VFGDebugLog("Skipping updateCell for section:\(index)")
            return
        }
        setupCell(header.itemView, with: item)
    }

    private func indexPaths(fromRow row: Int, count: Int) -> [IndexPath] {
        var indexes: [IndexPath] = []
        for idx in 0..<count {
            indexes.append(IndexPath(row: row + idx, section: 0))
        }
        return indexes
    }

    fileprivate func updateAlpha(for itemView: VFGSideMenuItemView, with alpha: CGFloat) {
        itemView.titleLabel.alpha = alpha
        itemView.separator.alpha = alpha
    }

    private func hideSubTitles(for item: VFGSideMenuItem) {
        guard let section = model?.index(forItem: item) else { return }
        for idx in 0 ..< item.subitemsCount() {
            let indexPath = IndexPath(row: idx, section: section)
            guard let cell = tableView?.cellForRow(at: indexPath) as? VFGSideMenuTableViewCell else {
                VFGErrorLog("Cannot unwrap data for VFGSideMenuTableViewCell")
                return
            }

            updateAlpha(for: cell.itemView, with: 0.3)
            UIView.animate(withDuration: 0.18, animations: { [weak self] in
                self?.updateAlpha(for: cell.itemView, with: 0)
            })
        }

    }

    private func showSubTitles(item: VFGSideMenuItem) {
        guard let section = model?.index(forItem: item) else { return }
        for idx in 0 ..< item.subitemsCount() {
            let indexPath = IndexPath(row: idx, section: section)
            guard let cell = tableView?.cellForRow(at: indexPath) as? VFGSideMenuTableViewCell else {
                VFGErrorLog("Cannot unwrap data for VFGSideMenuTableViewCell")
                return
            }

            updateAlpha(for: cell.itemView, with: 0)
            UIView.animate(withDuration: 0.7, animations: {  [weak self] in
                self?.updateAlpha(for: cell.itemView, with: 1)
            })
        }
    }

    private func processStatusBar() {
        //handle if iPhone X hide & show the status bar when showing & hiding the side menu.
        if UIScreen.hasNotch {
            UIView.animate(withDuration: 1, animations: {
                if VFGRootViewController.shared.isStatusBarHidden == true {
                    VFGRootViewController.shared.isStatusBarHidden = false
                }
            })
        }
    }

    private func trackDidSelectEvent(title: String) {
        if !VFGSideMenuViewController.shouldSendTags {
            return
        }
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .uiInteraction,
                                               actionName: .menuClick,
                                               categoryName: .uiInteractions,
                                               eventLabel: .sideMenuClick,
                                               pageName: sharedRootVC.currentPage(),
                                               nextPageName: title)
    }

    func reloadTable() {
        let nextViewController = sharedRootVC.containerNavigationController.viewControllers.last
        if nextViewController == sharedRootVC.containerNavigationController.viewControllers.first {
            lastSelectedItem?.isItemSelected = false
            lastSelectedItem = nil
        } else if currentViewController != nextViewController {
            model?.updateVisibility(at: 0, visible: true)
        }
        currentViewController = nextViewController
        tableView?.reloadData()
    }

}

extension VFGSideMenuTableModel {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model?.isExpanded(at: section) ?? false {
            return model?.item(at: section)?.subitemsCount() ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VFGSideMenuTableModel.headerIdentifier)
        guard let sideMenuHeader: VFGSideMenuTableViewHeader = header as? VFGSideMenuTableViewHeader else {
            VFGErrorLog("Cannot cast data to VFGSideMenuTableViewHeader")
            return header
        }
        guard let item: VFGSideMenuItem = model?.item(at: section) else {
            VFGErrorLog("Cannot unwrap side menu item data")
            return sideMenuHeader
        }

        setupCell(sideMenuHeader.itemView, with: item)

        sideMenuHeader.itemView.tapAction = { [weak self] in
            guard let self = self else { return }
            if item.isExpandable {

                if self.model?.isExpanded(at: section ) ?? false {
                    self.collapseSection(section, with: item)
                } else {
                   self.expandSection(section, with: item)
                }
                self.lastExpandedSection = section
            } else {
                self.cellTapped(at: section, with: item)
            }

        }
        if #available(iOS 14.0, *) {
            sideMenuHeader.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        return sideMenuHeader
    }

    func collapseSection(_ section: Int, with item: VFGSideMenuItem) {
        updateExpandViewFor(section, with: item)
        hideSubTitles(for: item)
        model?.collapseItem(at: section, hasSeparator: item.separator)
        tableView?.beginUpdates()
        tableView?.reloadSections([section], with: .automatic)
        tableView?.endUpdates()
    }

    func expandSection(_ section: Int, with item: VFGSideMenuItem) {
        guard !isExpanding else {
            return
        }
        isExpanding = true
        collapseAll()
        let sections: IndexSet = [section]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.updateExpandViewFor(section, with: item)
            self?.tableView?.beginUpdates()
            self?.model?.expandItem(at: section, hasSeparator: item.separator)
            self?.tableView?.reloadSections(sections, with: .automatic)
            self?.tableView?.endUpdates()
            self?.showSubTitles(item: item)
            self?.isExpanding = false
        })
    }

    func updateExpandViewFor(_ section: Int, with item: VFGSideMenuItem) {
        if let headerView = tableView?.headerView(forSection: section) as? VFGSideMenuTableViewHeader,
            let isExpanded = model?.isExpanded(at: section ) {
            headerView.itemView.expandButton.isSelected = isExpanded
            if isExpanded == true {
                headerView.itemView.separator.alpha = 0.3
                UIView.animate(withDuration: 0.18, animations: {
                    headerView.itemView.separator.alpha = 0
                })
            } else {
                headerView.itemView.separator.alpha = 0
                UIView.animate(withDuration: 0.7, animations: {
                    headerView.itemView.separator.alpha = 1
                })
            }
        }
    }

    fileprivate func setupCell( _ sideMenuCell: VFGSideMenuItemView, with item: VFGSideMenuItem) {
        guard let model = model else {
            VFGErrorLog("Cannot cast data to VFGSideMenuTableViewCell")
            return
        }

        if item == lastSelectedItem {
            sideMenuCell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            sideMenuCell.selectedCellWhiteView.isHidden = false
        } else {
            sideMenuCell.backgroundColor = .clear
            sideMenuCell.selectedCellWhiteView.isHidden = true
        }

        sideMenuCell.isHidden = !item.visible

        sideMenuCell.titleLabel.textColor = sideMenuCellColor
        sideMenuCell.rightImage.tintColor = sideMenuCellColor
        sideMenuCell.leftImage.tintColor = sideMenuCellColor
        sideMenuCell.separator.backgroundColor = sideMenuCellColor
        sideMenuCell.expandButton.imageView?.tintColor = sideMenuCellColor

        sideMenuCell.expandButton?.isHidden = !item.isExpandable

        let isExpanded = model.isExpanded(at: model.index(forItem: item) )
        sideMenuCell.expandButton.isSelected = isExpanded

        if sideMenuCell.expandButton.isHidden {
            sideMenuCell.expandButtonWidthConstraint.constant = 0
        } else {
            sideMenuCell.expandButtonWidthConstraint.constant = VFGSideMenuTableModel.expandButtonWidth
        }
        sideMenuCell.titleLabel.text = item.title
        sideMenuCell.leftImage.image = item.image
        sideMenuCell.rightImage.image = item.rightImage
        sideMenuCell.separator.isHidden = !item.separator
        sideMenuCell.badge.isHidden = model.badgeTextForItem(item)?.isEmpty ?? true
        if sideMenuCell.badge.isHidden == false {
            sideMenuCell.badge.text = model.badgeTextForItem(item)
        }
        sideMenuCell.titleLabel.alpha = 1
        sideMenuCell.setInfoImage(image: item.infoImage, position: item.infoImagePosition)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VFGSideMenuTableModel.cellIdentifier,
                                                 for: indexPath)
        guard let sideMenuCell: VFGSideMenuTableViewCell = cell as? VFGSideMenuTableViewCell,
              let model = self.model else {
                VFGErrorLog("Cannot cast data to VFGSideMenuTableViewCell")
                return cell
        }
        let row: Int = indexPath.row

        guard let mainItem =  model.item(at: indexPath.section),
            mainItem.subitems.count > row else {
            VFGErrorLog("Cannot unwrap side menu item data")
            return sideMenuCell
        }
        let item: VFGSideMenuItem = mainItem.subitems[row]
        setupCell(sideMenuCell.itemView, with: item)

        sideMenuCell.itemView.tapAction = { [weak self] in
            self?.cellTapped(at: indexPath.row, with: item)
        }
        return cell
    }

    func cellTapped(at index: Int, with item: VFGSideMenuItem) {

        guard let callback = itemAtRowClickedCallback else {
            return
        }

        trackDidSelectEvent(title: item.title)
        lastSelectedItem?.isItemSelected = false
        item.isItemSelected = true
        lastSelectedItem = item
        callback(index, item)
    }
}
