//
//  VFGAlertViewDynamic.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/22/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import RBBAnimation
import VFGCommonUtils

@objc public class VFGConfigurableAlertView: UIViewController {

    // MARK: - Class Constants
    private static let closeIcon = "close"
    private static let sidePadding: CGFloat = 30.5

    // MARK: - View Outlets
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thridButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    // MARK: - Instance properties
    private var firstButtonCallBack: (() -> Void)?
    private var secondButtonCallBack: (() -> Void)?
    private var thirdButtonCallBack: (() -> Void)?
    private var closeButtonCallback: (() -> Void)?
    private var shouldSendTags: Bool = true

    // MARK: - Setup  public methods

    /**
     A method that configures and returns an overlay configurable View
     
     - parameter title: the title text to view on the overlay
     - parameter subView: The view to insert in the overlay
     - parameter closeButtonCallback : the close button callback
     
     - returns: an instanse of the configurable AlertView
     */
    public static func configureView<T: UIView>(title: String,
                                                subView: T,
                                                closeButtonCallback: (() -> Void)?,
                                                shouldSendTags: Bool = true) ->
            VFGConfigurableAlertView? where T: SizeableView {
        let alertView = UIViewController.configurableAlertViewController()
        let screenWidth = UIScreen.main.bounds.width

        alertView.view.backgroundColor = UIColor.VFGBlackTwo
        alertView.headerTitle.text = title
        alertView.headerTitle.applyStyle(VFGTextStyle.headerColored(UIColor.VFGWhite))
        alertView.closeButton.tintColor = UIColor.white
        alertView.closeButton.setImage(UIImage(fromCommonUINamed: closeIcon)?.withRenderingMode(.alwaysTemplate),
                                       for: .normal)
        subView.frame.size = CGSize(width: screenWidth - (sidePadding * 2), height: subView.frame.height)

        let viewHeight = subView.getViewHeight()

        subView.frame = CGRect(origin: CGPoint.zero,
                               size: CGSize(width: alertView.containerView.frame.width, height: viewHeight))
        alertView.containerView.frame.size = subView.frame.size
        alertView.containerView.addSubview(subView)

        alertView.containerHeight.constant = viewHeight
        alertView.closeButtonCallback = closeButtonCallback

        alertView.firstButton.isHidden = true
        alertView.secondButton.isHidden = true
        alertView.thridButton.isHidden = true
        alertView.shouldSendTags = shouldSendTags
        return alertView
    }

    @objc public static func configure(with viewModel: VFGConfigurableAlertViewModel) -> VFGConfigurableAlertView? {

        guard let view: VFGCustomView = VFGCustomView.fromNib() else {
            return nil
        }
        view.setUpView(header: viewModel.header,
                       paragraph: viewModel.paragraph,
                       img: viewModel.img,
                       imgHeight: Float(viewModel.imgSize.height),
                       imgWidth: Float(viewModel.imgSize.width))
        return VFGConfigurableAlertView.configureView(title: viewModel.title,
                                                      subView: view,
                                                      closeButtonCallback: viewModel.closeButtonCallback,
                                                      shouldSendTags: viewModel.shouldSendTags)
    }

    /// Use to show and configure the frist button with title and callback action and optoinal style
    public func configureFirstButton(title: String,
                                     style: VFGButtonStyle = VFGButtonStyle.primaryButton,
                                     callBack: (() -> Void)?) -> VFGConfigurableAlertView {
        firstButton.isHidden = false
        firstButton.titleLabel?.text = title
        firstButton.setTitle(title, for: .normal)
        firstButton.applyStyle(style)
        firstButtonCallBack = callBack
        return self
    }

    /// Use to show and configure the second button with title and callback action and optoinal style
    public func configureSecondButton(title: String,
                                      style: VFGButtonStyle = VFGButtonStyle.secondryButton,
                                      callBack: (() -> Void)?) -> VFGConfigurableAlertView {
        secondButton.isHidden = false
        secondButton.titleLabel?.text = title
        secondButton.setTitle(title, for: .normal)
        secondButton.applyStyle(style)
        secondButtonCallBack = callBack
        return self
    }

    /// Use to show and configure the second button with title and callback action and optoinal style
    public func configureThirdButton(title: String,
                                     style: VFGButtonStyle = VFGButtonStyle.tertiaryButton,
                                     callBack: (() -> Void)?) -> VFGConfigurableAlertView {
        thridButton.isHidden = false
        thridButton.titleLabel?.text = title
        thridButton.setTitle(title, for: .normal)
        thridButton.applyStyle(style)
        thirdButtonCallBack = callBack

        return self
    }

    /// Use to change the padding between the overlay title and the injected view
    @objc public func topPadding(_ padding: Float) -> VFGConfigurableAlertView {
        topPadding.constant = CGFloat(padding)
        return self
    }

    /// Call this method to show the alert view
    @objc public func show() {

        if let topController = getTopViewController() {
            VFGRootViewController.shared.hideNudgeView()
            if #available(iOS 13.0, *) {
                self.modalPresentationStyle = .overFullScreen
            }
            topController.present(self, animated: true, completion: nil)
            if shouldSendTags {
                VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageView,
                                                       actionName: .interstitialViewed,
                                                       categoryName: .interstitial,
                                                       eventLabel: .interstitialMessageViewed,
                                                       pageName: VFGRootViewController.shared.currentPage())
            }
        }
    }

    // MARK: - View Actions

    @IBAction func closebuttonClicked(_ sender: Any) {
        if shouldSendTags {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageDismiss,
                                                   actionName: .interstitialDiscarded,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageDismissed,
                                                   pageName: VFGRootViewController.shared.currentPage())
        }
        dismiss(animated: true, completion: closeButtonCallback)
    }

    @IBAction func firstButtonClicked(_ sender: Any) {
        if shouldSendTags {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageClick,
                                                   actionName: .interstitialClicked,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageClicked,
                                                   pageName: VFGRootViewController.shared.currentPage())
        }
        dismiss(animated: true, completion: firstButtonCallBack)
    }

    @IBAction func secondButtonClicked(_ sender: Any) {
        if shouldSendTags {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageClick,
                                                   actionName: .interstitialClicked,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageClicked,
                                                   pageName: VFGRootViewController.shared.currentPage())
        }
        dismiss(animated: true, completion: secondButtonCallBack)
    }

    @IBAction func thirdButtonClicked(_ sender: Any) {
        if shouldSendTags {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageClick,
                                                   actionName: .interstitialClicked,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageClicked,
                                                   pageName: VFGRootViewController.shared.currentPage())
        }
        dismiss(animated: true, completion: thirdButtonCallBack)
    }

    // MARK: - View lifecycle
    @objc public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
