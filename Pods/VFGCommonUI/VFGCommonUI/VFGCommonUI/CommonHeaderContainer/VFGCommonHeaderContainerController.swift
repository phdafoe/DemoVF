//
//  VFGCommonHeaderContainerController.swift
//  VFGCommon
//
//  Created by kasa on 10/11/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Object of this class serve as container for other view controllers.
 This class provides chipped view, image background and possibility to scroll the view.
 Contained viewss are put inside chipped view
 */
@objc public class VFGCommonHeaderContainerController: UIViewController, VFGViewControllerContent {

    static private let backgroundImageName = "CommonHeaderContainerBackground"

    static let horizontalContentMargin: CGFloat = UIScreen.isIpad ? 30.0 : 10.0
    static let headerFontSize: CGFloat = UIScreen.isIpad ? 39.9 : 30.0

    /**
     content Top Margin To TopBar, default = 93.0
     */

    @objc public var contentTopMarginToTopBar: CGFloat = UIScreen.isIpad ? 117.0 : 93.0
    static let headerLabelMarginToContent: CGFloat = UIScreen.isIpad ? 40.0 : 24.0

    @IBOutlet weak var shadowBackgroundView: VFGChippedShadowView!

    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var headerLabel: UILabel!

    /**
     Title of header presented above chipped view.
     */
    @objc public var headerTitle: String? {
        didSet {
            self.headerLabel?.text = headerTitle
        }
    }

    /**
     The background image of the container controller.
     */
    @objc public var backgroundImage: UIImage? = UIImage(named: VFGCommonHeaderContainerController.backgroundImageName,
                                                         in: Bundle.vfgCommonUI,
                                                         compatibleWith: nil) {
        didSet {
            self.backgroundImageView?.image = backgroundImage
        }
    }

    // MARK: VFGViewControllerContent
    public var statusBarState: VFGRootViewControllerStatusBarState = .defaultState
    @objc public var topBarScrollState: VFGTopBarScrollState? = VFGTopBarScrollState()
    @objc public var topBarTitle: String = ""
    @objc public var topBarRightButtonHidden: Bool = false

    var containerYOffsetBasedOnContenView: CGFloat = 0 {
        didSet {
            headerLabel.frame = self.currentFrameForHeaderLabel()
            shadowBackgroundView.frame = self.currentFrameForShadowBackground()
            topBarScrollState?.didScroll(withOffset: containerYOffsetBasedOnContenView)
        }
    }

    var contentOriginYBasedOnContainer: CGFloat = 0 {
        didSet {
            topBarScrollState?.alphaChangeYPosition = contentOriginYBasedOnContainer
            scrollableContainedViewController?.originY = contentOriginYBasedOnContainer
        }
    }

    @objc public var containedController: UIViewController?
    @objc public var scrollableContainedViewController: VFGCommonHeaderContentController?

    /**
     Creates common header component with not scrollable container views
     
     - Parameter withViewController: View controller which will be put inside this controller
     
     */
    @objc static public func commonHeaderContainerController(withViewController viewController: UIViewController) ->
        VFGCommonHeaderContainerController {
        let commonHeaderVC = UIViewController.commonHeaderViewController()
        commonHeaderVC.addChild(viewController)
        commonHeaderVC.view.addSubview(viewController.view)
        commonHeaderVC.containedController = viewController
        commonHeaderVC.didMove(toParent: viewController)
        return commonHeaderVC
    }

    /**
     Creates common header component with scrollable container views
     
     - Parameter withViewController: View controller which will be put inside this controller and based on which
                                     scroll the container views will be moved
     
     */
    @objc static public func scrollableCommonHeaderContainerController(withViewController
        viewController: VFGCommonHeaderContentController) -> VFGCommonHeaderContainerController {
        let commonHeaderVC: VFGCommonHeaderContainerController =
            commonHeaderContainerController(withViewController: viewController)
        viewController.adjustedScrollOffsetChangedCallback = { [weak commonHeaderVC] (offset: CGFloat) in
            commonHeaderVC?.containerYOffsetBasedOnContenView = offset
        }
        commonHeaderVC.scrollableContainedViewController = viewController
        return commonHeaderVC
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBackgroundImage()
        setupHeader()
    }

    private func setupBackgroundImage() {
        backgroundImageView.image = backgroundImage
    }

    private func setupHeader() {
        topBarTitle = headerTitle ?? ""
        headerLabel.font = UIFont.vodafoneRegularFont(VFGCommonHeaderContainerController.headerFontSize)
        headerLabel.minimumScaleFactor = 0.5
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .center
        headerLabel.text = headerTitle
        view.addSubview(headerLabel)
    }

    private func setupBackground() {
        shadowBackgroundView.visibleBackgroundColor = UIColor.VFGChippViewBackground
        view.addSubview(shadowBackgroundView)
    }

    private func currentFrameForHeaderLabel() -> CGRect {
        var frame = baseFrameForHeaderLabel()
        frame.origin.y -= containerYOffsetBasedOnContenView
        return frame
    }

    private func currentFrameForShadowBackground() -> CGRect {
        var frame = baseFrameForShadowBackground()
        frame.origin.y -= containerYOffsetBasedOnContenView
        frame.size.height += containerYOffsetBasedOnContenView
        return frame
    }

    private func baseFrameForHeaderLabel() -> CGRect {
        let size = headerLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                   height: CGFloat.greatestFiniteMagnitude))
        var frame = CGRect(origin: CGPoint.zero, size: size)
        frame.origin.x = (view.bounds.width - frame.size.width)/2
        frame.origin.y = baseFrameForShadowBackground().minY -
            VFGCommonHeaderContainerController.headerLabelMarginToContent - size.height
        return frame
    }

    private func baseFrameForShadowBackground() -> CGRect {
        var frame = self.view.bounds
        frame.origin.y = VFGTopBar.topBarHeight + self.contentTopMarginToTopBar
        frame.size.height -= frame.origin.y
        return frame
    }

    private func baseFrameForContentView() -> CGRect {
        return self.view.bounds.insetBy(dx: VFGCommonHeaderContainerController.horizontalContentMargin, dy: 0)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerLabel.frame = currentFrameForHeaderLabel()
        shadowBackgroundView.frame = currentFrameForShadowBackground()
        backgroundImageView.frame = view.bounds
        let contentYOrigin = computedContentYOrigin()
        if !contentOriginYBasedOnContainer.equalsWithEpsilon(other: contentYOrigin) {
            contentOriginYBasedOnContainer = contentYOrigin
        }
        if scrollableContainedViewController == nil {
            containedController?.view.frame = baseFrameForStaticContentView()
        } else {
            scrollableContainedViewController?.layoutContentInArea(baseFrameForContentView())
        }
    }

    private func computedContentYOrigin() -> CGFloat {
        var computedHeight = VFGCommonUISizes.statusBarHeight + baseFrameForShadowBackground().minY
        if UIScreen.isIpad {
            computedHeight += 12
        }
        return computedHeight
    }

    private func baseFrameForStaticContentView() -> CGRect {
        var frame: CGRect = self.baseFrameForContentView()
        frame.origin.y = self.baseFrameForShadowBackground().minY + VFGCommonUISizes.statusBarHeight
        frame.size.height -= (self.baseFrameForShadowBackground().minY + VFGCommonUISizes.statusBarHeight * 2)
        return frame
    }

}
