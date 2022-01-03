//
//  VFGScrollableTabBar.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 3/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

private let nibName: String = "VFGScrollableTabBar"
private let cellNibName: String = "VFGScrollableTabBarItemCell"
private let cellIdentifier: String = "ScrollableTabBarItemCell"
public  let noSelectionIndex: Int = -1
private let itemLabelLineSpacing: CGFloat = 0.3
private let itemLabelLineHeight: CGFloat = 15.1

/**
 The delegate for scrollable tabBar callBack methods
 */
@objc public protocol VFGScrollableTabBarDelegate: NSObjectProtocol {
    func scrollableTabBar(_ scrollableTabBar: VFGScrollableTabBar,
                          didSelectItemAt index: Int,
                          didSwitchToViewController: Bool)
}

/**
 Custom view that contains a TabBar that can be scrolled
 */
@objc open class VFGScrollableTabBar: UIView, UICollectionViewDataSource,
                                      UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var nibView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    /** The current selected item index */
    @objc public var selectedIndex: Int = noSelectionIndex

    /** The initial selected item index, default = 0 */
    @objc public var initialSelectedIndex: Int = 0

    /** The number of maximum items on screen without scrolling the tabBar, default = 4 */
    @objc public var maxItemsCountWithoutScrolling: Int = 4

    /** Enable tabBar scrolling, default = true */
    @objc public var isScrollingEnabled: Bool = true

    /** Show half of the next scrolling item , default = true */
    @objc public var shouldShowHalfItemWhenScrolling: Bool = true

    /** The items of the tabBar */
    @objc public lazy var tabBarItems: [VFGScrollableTabBarItem] = [VFGScrollableTabBarItem]()

    /** The item label Color for the selected item */
    @objc public var itemlabelSelectedColor: UIColor? = UIColor.VFGScrollableTabBarSelectedItemTintColor

    /** The item label Color for the UnSelected item */
    @objc public var itemlabelNormalColor: UIColor? = UIColor.VFGScrollableTabBarEnabledItemTintColor

    /** The image tint Color for the selected item */
    @objc public var selectedItemTintColor: UIColor? = UIColor.VFGScrollableTabBarSelectedItemTintColor

    /** The image tint Color for the enabled items */
    @objc public var enabledItemTintColor: UIColor? = UIColor.VFGScrollableTabBarEnabledItemTintColor

    /** The title font of the tabBar items  */
    @objc public var itemTitleFont: UIFont? = UIFont.vodafoneRegularFont(16.0)

    /** The view controllers that embedded on the TabBar  */
    public lazy var tabBarViewControllers: [UIViewController?] = []

    /** The view which displays the view controllers for the tabBar  */
    @objc public weak var viewControllersContainerView: UIView?

    /** The delegate for VFGScrollableTabBar */
    @objc public weak var delegate: VFGScrollableTabBarDelegate?

    /** The parent view controller which contains the tabBar */
    @objc public weak var parentViewController: UIViewController?

    /** Boolean to check the rendering mode of each icon and apply tint color to it accordingly */
    @objc public var shouldRenderAllIconsAsTemplate: Bool = true

    // MARK: Init

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScrollableTabBar()
    }

    @objc public required override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollableTabBar()
    }

    // MARK: Setup

    private func setupScrollableTabBar() {

        setupNib()
        setupCollectionView()
    }

    private func setupNib() {
        guard let bundleNibView = Bundle.vfgCommonUI.loadNibNamed(nibName,
                                                                  owner: self,
                                                                  options: nil)?.first as? UIView else {
                                                                    return
        }
        nibView = bundleNibView
        nibView.frame = bounds
        nibView.backgroundColor = backgroundColor
        addSubview(nibView)
    }

    private func setupCollectionView() {
        let cellNib = UINib(nibName: cellNibName, bundle: Bundle.vfgCommonUI)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)

        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    private func initialSetup() {
        guard selectedIndex == noSelectionIndex else { return }

        selectedIndex = initialSelectedIndex
        viewControllersContainerView?.subviews.forEach({$0.removeFromSuperview()})

        let shouldShowViewController: Bool = self.shouldShowViewController(atIndex: initialSelectedIndex)
        if shouldShowViewController {
            showViewControllerAtIndex(index: initialSelectedIndex)
        }
        delegate?.scrollableTabBar(self,
                                   didSelectItemAt: initialSelectedIndex,
                                   didSwitchToViewController: shouldShowViewController)
        collectionView.isScrollEnabled = isScrollingEnabled

        if initialSelectedIndex < tabBarItems.count {
            tabBarItems[initialSelectedIndex].status = .selected
        }
    }

    // Select item programatically with specified index path
    public func selectItem(at index: Int) {
        collectionView(collectionView, didSelectItemAt: IndexPath(row: index,
                                                                  section: 0))
    }

    @objc public func reloadData() {
        collectionView.reloadData()
    }

    // public function will be called to manager tabbar items notification status, you will pass the item index and
    // the function will check if that item is being displayed in notification mode or not, if not then it will
    // automatically switches it to that mode, otherswise it will switch it on.
    // finally reload the collection view.

    @objc public func triggerOrUnTriggerNotificationIconAtTabBarItems(index: Int, triggerOn: Bool) {
        guard tabBarItems.count > index else {
            VFGErrorLog("Item Index:\(index) is out of items array bounds")
            return
        }
        let item: VFGScrollableTabBarItem = tabBarItems[index]
        item.switchToNewNotificationMode(hasNewNotification: triggerOn)
        reloadData()
    }

    // MARK: ViewControllers

    private func removeViewControllerAtIndex(index: Int) {

        guard  index < tabBarItems.count else { return }

        if let viewController = tabBarItems[index].viewController {
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }

    private func viewController(at index: Int) -> UIViewController? {
        guard let viewController = tabBarItems[index].viewController else {
            return tabBarViewControllers[index]
        }
        return viewController
    }

    private func shouldShowViewController(atIndex: Int) -> Bool {
        return viewController(at: atIndex) != nil
    }

    private func showViewControllerAtIndex(index: Int) {
        guard index < tabBarViewControllers.count  || index < tabBarItems.count else { return }
        guard let viewController = viewController(at: index) else {
            return
        }
        showViewControllerFromTabbarItem(tabBarItemViewController: viewController)
    }

    func showViewControllerFromTabbarItem(tabBarItemViewController: UIViewController) {
        //remove every child before adding new one
        guard let count = parentViewController?.children.count else {
            return
        }
        for index in 0..<count {
            removeViewControllerAtIndex(index: index)
        }
        parentViewController?.addChild(tabBarItemViewController)
        if let viewControllersContainerViewBounds = viewControllersContainerView?.bounds {
            tabBarItemViewController.view.frame = viewControllersContainerViewBounds
        }
        viewControllersContainerView?.addSubview(tabBarItemViewController.view)
        tabBarItemViewController.didMove(toParent: parentViewController)
    }

    // MARK: UICollectionViewDataSource
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }

    @objc public func collectionView(_ collectionView: UICollectionView,
                                     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        initialSetup()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath)
        guard let itemCell = cell as? VFGScrollableTabBarItemCell else {
            return cell
        }
        let item = tabBarItems[indexPath.row]
        itemCell.alpha = (item.status == .disabled) ? disabledViewAlpha : enabledViewAlpha
        itemCell.iconImageView.image = item.image
        if !item.itemIconIsNewNotification() {
            if shouldRenderAllIconsAsTemplate {
                itemCell.iconImageView.image = item.image?.withRenderingMode(.alwaysTemplate)
                itemCell.iconImageView.tintColor = (item.status == .selected) ?
                    selectedItemTintColor : enabledItemTintColor
            } else {
                if item.image?.renderingMode == .alwaysTemplate {
                    itemCell.iconImageView.tintColor = (item.status == .selected) ?
                        selectedItemTintColor : enabledItemTintColor
                }
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = itemLabelLineSpacing
        paragraphStyle.maximumLineHeight = itemLabelLineHeight
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        guard let itemTitleFont: UIFont = itemTitleFont else {
            VFGErrorLog("Cannot unwrap itemTitleFont. Skipping cell text customization")
            return cell
        }
        let attributes = [kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle,
                          kCTFontAttributeName as NSAttributedString.Key: itemTitleFont]
        itemCell.titleLabel.attributedText = NSAttributedString(string: item.title ?? "",
                                                                attributes: attributes)
        guard let itemTitle: String = item.title else {
            VFGErrorLog("Cannot unwrap itemTitle")
            return itemCell
        }
        if selectedIndex == indexPath.row {
            itemCell.titleLabel.textColor = itemlabelSelectedColor ?? selectedItemTintColor
        } else {
            itemCell.titleLabel.textColor = itemlabelNormalColor
        }
        itemCell.titleLabel.numberOfLines = (itemTitle.contains("\n")) ? 2 : 1
        itemCell.accessibilityIdentifier = item.title
        return itemCell
    }

    // MARK: UICollectionViewDelegate

    @objc public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  tabBarItems[indexPath.row].status == .disabled { return }

        let shouldShowViewController: Bool = self.shouldShowViewController(atIndex: indexPath.row)
        if selectedIndex == indexPath.row,
            let nav = tabBarViewControllers[indexPath.row] as? UINavigationController {
            nav.popToRootViewController(animated: true)
        } else {
            selectedIndex = indexPath.row

            if shouldShowViewController {
                showViewControllerAtIndex(index: selectedIndex)
                tabBarItems.filter({ $0.status != .disabled }).forEach { $0.status = .enabled }
                tabBarItems[indexPath.row].status = .selected
                collectionView.reloadData()
            }
        }
        delegate?.scrollableTabBar(self,
                                   didSelectItemAt: indexPath.row,
                                   didSwitchToViewController: shouldShowViewController)
        if isScrollingEnabled {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    // MARK: UICollectionViewDelegateLayoutFlow

    @objc public func collectionView(_ collectionView: UICollectionView,
                                     layout collectionViewLayout: UICollectionViewLayout,
                                     sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = self.bounds.height
        var cellWidth = self.bounds.width / CGFloat(tabBarItems.count)
        if tabBarItems.count > maxItemsCountWithoutScrolling {
            cellWidth = self.bounds.width / CGFloat(maxItemsCountWithoutScrolling)
            if shouldShowHalfItemWhenScrolling {
                cellWidth = (self.bounds.width - (cellWidth/2)) / CGFloat(maxItemsCountWithoutScrolling)
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
