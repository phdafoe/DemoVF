//
//  SideMenuViewController.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 09/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import RBBAnimation
import VFGCommonUtils

/**
 View controller containing side menu.
 */
public class VFGSideMenuViewController: UIViewController {

    static let closeButtonImage: String = "close"
    public var closeButtonTintColor: UIColor = .VFGTopBarTitleColor {
        didSet {
            closeButton.imageView?.tintColor = closeButtonTintColor
        }
    }
    public var backgroundColor: UIColor = .clear {
        didSet {
            tableView.backgroundColor = backgroundColor
        }
    }

    static var shouldSendTags: Bool = true

    var animationInProgress: Bool = false
    var closeButtonSpacingToTopViewMargin: CGFloat = 10
    public var itemsModel: VFGSideMenuAbstractModel?
    @IBOutlet public weak var tableView: UITableView!

    public var isStatusBarHidden: Bool = false {
        didSet(newValue) {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var closeButtonVerticalConstraint: NSLayoutConstraint!
    var hideMenuBackground : (() -> Void)?

    /**
     Callback called when item at given row in menu was clicked.
     */
    @objc public var itemAtRowClickedCallback : ((_ row: Int, _ item: VFGSideMenuItem) -> Void)? {
        get {
            return self.tableModel.itemAtRowClickedCallback
        }
        set {
            self.tableModel.itemAtRowClickedCallback = newValue
        }
    }

    @objc public func clearLastSelectedMenuItem() {
        let selectedItem = self.tableModel.lastSelectedItem
        selectedItem?.isItemSelected = false
    }

    @objc public func changeCurrentViewController() {
        let viewControllers = VFGRootViewController.shared.containerNavigationController.viewControllers
        tableModel.currentViewController = viewControllers.last
    }

    static var sideMenuFactory: VFGSideMenuFactory = VFGSideMenuFactory()
    private lazy var frameGenerator = VFGSideMenuViewController.sideMenuFactory.frameGenerator()
    private var positionAnimator: VFGSideMenuPositionAbstractAnimator {
        var animator: VFGSideMenuPositionAbstractAnimator = VFGSideMenuViewController.sideMenuFactory.positionAnimator()
        animator.sideMenu = self.view
        return animator
    }
    private lazy var tableModel: VFGSideMenuTableModel = VFGSideMenuViewController.sideMenuFactory.tableModel()

    /**
     Loads and initializes side menu view controller. View controller is added to desired view controller and as
     a subview of view controller's view
     */
    @objc static public func sideMenuViewController(inViewController controller: UIViewController) ->
        VFGSideMenuViewController {
        return sideMenuViewController(inViewController: controller, containerView: controller.view)
    }

    /**
     Loads and initializes side menu view controller.
     View controller is added to desired view controller and view is added to containerView.
     */
    @objc static public func sideMenuViewController(inViewController controller: UIViewController,
                                                    containerView: UIView) -> VFGSideMenuViewController {
        let sideMenuVC = UIViewController.sideMenuViewController()
        controller.addChild(sideMenuVC)
        containerView.addSubview(sideMenuVC.view)
        sideMenuVC.frameGenerator.setParent(containerView)
        sideMenuVC.frameGenerator.setSideMenu(sideMenuVC.view)
        sideMenuVC.didMove(toParent: controller)
        sideMenuVC.layoutMenu()
        return sideMenuVC
    }

    /**
     Show side menu with or without animation.
     
     - Parameter withAnimation: True if showing of side menu should be animated
     
     */
    @objc public func showMenu(withAnimation: Bool = false) {
        if !animationInProgress {
            //handle if iPhone X hide & show the status bar when showing & hiding the side menu.
            if UIScreen.hasNotch {
                UIView.animate(withDuration: 1, animations: {[weak self] in
                    guard let `self` = self else {
                        return
                    }
                    self.isStatusBarHidden = true
                })
            }

            animationInProgress = true
            UIApplication.shared.keyWindow?.endEditing(true)
            let fromPosition: CGPoint = frameGenerator.currentMenuPosition()
            frameGenerator.state = .shown
            if withAnimation {
                animateToCurrentPosition(fromPosition: fromPosition)
                rootViewController?.fadeInOverlay(withDuration: VFGSideMenuPositionAnimator.duration)
            } else {
                animationInProgress = false
            }

            layoutMenu()
            //sideMenu selection
            tableModel.collapseAll()
            tableModel.reloadTable()
        }
    }

    /**
     Hide side menu with or without animation.
     
     - Parameter withAnimation: True if hidding of side menu should be animated
     
     */
    @objc public func hideMenu(withAnimation: Bool = false) {
        if !self.animationInProgress {
            UIView.animate(withDuration: 1, animations: {[weak self] in
                guard let `self` = self else {
                    return
                }
                self.isStatusBarHidden = false
            })

            animationInProgress = true
            let fromPosition: CGPoint = self.frameGenerator.currentMenuPosition()
            frameGenerator.state = .hidden
            if withAnimation {
                animateToCurrentPosition(fromPosition: fromPosition)
                rootViewController?.fadeOutOverlay(withDuration: VFGSideMenuPositionAnimator.duration)
            } else {
                animationInProgress = false
                rootViewController?.fadeOutOverlay(withDuration: 0)
            }
            layoutMenu()
        }
    }

    /**
     Layout side menu in its parent view. Menu can be shown or hidden.
     */
    @objc public func layoutMenu() {
        view.frame = frameGenerator.currentMenuFrame()
    }

    /**
     Sets menu items which are displayed in menu
     
     - Parameter items: Items displayed in menu
     
     */
    @objc public func setMenuItems(_ items: [VFGSideMenuItem], withColor color: UIColor = .VFGTopBarTitleColor) {
        itemsModel = VFGSideMenuModel(items: items)
        self.tableModel.model = itemsModel
        self.tableModel.sideMenuCellColor = color
    }

    /**
     Set text on badge on given item
     
     - Parameter text: Text displayed on badge
     - Parameter item: Menu item for which text is displayed
     
     */
    @objc public func setBadgeText(_ text: String?, forMenuItem item: VFGSideMenuItem) {
        let oldText: String? = tableModel.model?.badgeTextForItem(item)

        if oldText == text {
            return
        }

        tableModel.model?.setBadgeText(text, forItem: item)

        if let index: Int = tableModel.model?.index(forItem: item) {
            tableModel.updateCell(at: index)
        }
    }

    func animateToCurrentPosition(fromPosition: CGPoint) {
        let positionAnimator: VFGSideMenuPositionAbstractAnimator = self.positionAnimator
        let toPosition: CGPoint = self.frameGenerator.currentMenuPosition()

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.animationInProgress = false
        }
        positionAnimator.animatePositionChange(fromPosition: fromPosition, toPosition: toPosition)
        CATransaction.commit()

    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.constraint(withIdentifier: "top")?.constant = UIScreen.isDeviceVersionIphoneXOrNewer() ? 0 : 20

        closeButton.imageView?.tintColor = UIColor.white

        let closeButtonImage = UIImage(fromCommonUINamed: VFGSideMenuViewController.closeButtonImage)?
            .withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeButtonImage, for: .normal)

        menuBackgroundView.backgroundColor = UIColor.VFGMenuBackground

        tableView.backgroundColor = UIColor.clear
        tableModel.tableView = tableView

        setupGradientView()
        setupCloseButtonPosition()
    }

    func setupCloseButtonPosition() {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let statusBarHeight = Swift.min(statusBarSize.width, statusBarSize.height)
        closeButtonVerticalConstraint.constant = statusBarHeight + closeButtonSpacingToTopViewMargin
    }

    func setupGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView.bounds
        gradient.colors = [backgroundColor.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        self.gradientView.layer.mask = gradient
        self.gradientView.backgroundColor = backgroundColor
    }

    @IBAction func closeMenuClicked(_ sender: Any) {
        self.hideMenu(withAnimation: true)
        self.hideMenuBackground?()
    }

    @IBAction func menuBackgroundClicked(_ sender: Any) {
        self.hideMenu(withAnimation: true)
        self.hideMenuBackground?()
    }
    public override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

}
