//
//  VFGAlertViewController+ExtraTags.swift
//  VFGCommonUI
//
//  Created by Mohamed ELMeseery on 12/26/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension VFGAlertViewController {

    @objc static public func showAlert(with viewModel: VFGAlertViewModel) {
        let alertViewController = setupAlert(with: viewModel)
        guard let topViewController = getTopViewController() else {
            return
        }
        if #available(iOS 13.0, *) {
            alertViewController.modalPresentationStyle = .overFullScreen
        }
        topViewController.present(alertViewController, animated: false, completion: nil)
        alertViewController.trackEventOfAlertViewed()
    }

    @objc static public func setupAlert(with viewModel: VFGAlertViewModel) -> VFGAlertViewController {

        let alertViewController = UIViewController.alertViewController()
        currentScreen = VFGRootViewController.shared.currentPage()

        alertViewController.loadViewIfNeeded()
        alertViewController.closeButton.isHidden = !viewModel.closeButtonVisible
        alertViewController.titleLabel.text = viewModel.alertTitle
        let attributedString = NSAttributedString(with: viewModel.alertMessage,
                              and: viewModel.alertSubmessage)
        alertViewController.messageLabel.attributedText = attributedString
        alertViewController.primaryButton.setTitle(viewModel.primaryButtonText, for: .normal)
        alertViewController.primaryButtonAction = viewModel.primaryButtonAction
        alertViewController.isCampaign = viewModel.isCampaign
        alertViewController.campaignId = viewModel.campaignId
        alertViewController.shouldSendTags = viewModel.shouldSendTags
        alertViewController.extraTags = viewModel.extraTags
        alertViewController.primaryURL = viewModel.primaryURL
        alertViewController.secondaryURL = viewModel.secondaryURL

        if viewModel.primaryButtonText.isEmpty {
            alertViewController.primaryButton.isHidden = true
        } else {
            alertViewController.primaryButton.setTitle(viewModel.primaryButtonText, for: .normal)
            alertViewController.primaryButtonAction = viewModel.primaryButtonAction
        }

         if !viewModel.secondaryButtonText.isEmpty {
            alertViewController.secondaryButton.setTitle(viewModel.secondaryButtonText, for: .normal)
            alertViewController.secondaryButtonAction = viewModel.secondaryButtonAction
        } else {
            alertViewController.secondaryButton.isHidden = true
        }

        if !viewModel.tertiaryButtonText.isEmpty {
            alertViewController.tertiaryButton.setTitle(viewModel.tertiaryButtonText, for: .normal)
            alertViewController.tertiaryButtonAction = viewModel.tertiaryButtonAction
        } else {
            alertViewController.tertiaryButton.isHidden = true
        }

        alertViewController.closeButtonAction = viewModel.closeButtonAction
        alertViewController.configureIcon(viewModel.icon)
        return alertViewController
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlertWithSubView(title titleString: String?,
                                                  view subview: UIView?,
                                                  showCloseButton closeButtonVisible: Bool,
                                                  closeButtonAction: (() -> Void)? = nil,
                                                  isCampaign: Bool = false,
                                                  campaignId: String? = nil,
                                                  shouldSendTags: Bool = true,
                                                  extraTags: [String: String]? = nil) {
        let alertViewController = setupAlertview(
            titleString: titleString,
            subview: subview,
            closeButtonVisible: closeButtonVisible,
            closeButtonAction: closeButtonAction,
            isCampaign: isCampaign,
            campaignId: campaignId,
            shouldSendTags: shouldSendTags,
            extraTags: extraTags)
        if let topViewController = getTopViewController() {
            if #available(iOS 13.0, *) {
                alertViewController.modalPresentationStyle = .overFullScreen
            }
            topViewController.present(alertViewController, animated: false, completion: nil)
            alertViewController.trackEventOfAlertViewed()
        }
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static func setupAlertview(titleString: String?,
                                     subview: UIView?,
                                     closeButtonVisible: Bool,
                                     closeButtonAction: (() -> Void)? = nil,
                                     isCampaign: Bool = false,
                                     campaignId: String? = nil,
                                     shouldSendTags: Bool = true,
                                     extraTags: [String: String]? = nil) -> VFGAlertViewController {
        let alertViewController = UIViewController.alertViewController()
        alertViewController.isStatusBarHidden = true
        currentScreen = VFGRootViewController.shared.currentPage()
        alertViewController.loadViewIfNeeded()
        alertViewController.templateAlertContainerView.isHidden = true
        alertViewController.closeButton.isHidden = !closeButtonVisible

        alertViewController.isCampaign = isCampaign
        alertViewController.campaignId = campaignId
        alertViewController.shouldSendTags = shouldSendTags
        alertViewController.extraTags = extraTags

        if let titleString = titleString, !titleString.isEmpty {
            alertViewController.titleLabel.text =  titleString
        } else {
            alertViewController.titleLabelTopConstraint.constant = 0
            alertViewController.titleLabelHeightConstriant.constant = 0
        }

        if let configurableSubview = subview {
            alertViewController.configurableSubview.isHidden = false
            alertViewController.configurableSubview.clipsToBounds = true
            configurableSubview.frame = alertViewController.configurableSubview.bounds
            alertViewController.configurableSubview.addSubview(configurableSubview)
        }
        alertViewController.closeButtonAction = closeButtonAction
        return alertViewController
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlertWithSubView(view subView: UIView,
                                                  isCampaign: Bool = false,
                                                  campaignId: String? = nil,
                                                  shouldSendTags: Bool = true,
                                                  extraTags: [String: String]? = nil) {
        let alertViewController = setupAlertview(view: subView,
                                                 isCampaign: isCampaign,
                                                 campaignId: campaignId,
                                                 shouldSendTags: shouldSendTags,
                                                 extraTags: extraTags)

        if let topViewController = getTopViewController() {
            if #available(iOS 13.0, *) {
                alertViewController.modalPresentationStyle = .overFullScreen
            }
            topViewController.present(alertViewController, animated: false, completion: nil)
            alertViewController.trackEventOfAlertViewed()
        }
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static func setupAlertview(view subView: UIView,
                                     isCampaign: Bool = false,
                                     campaignId: String? = nil,
                                     shouldSendTags: Bool = true,
                                     extraTags: [String: String]? = nil) -> VFGAlertViewController {
        let alertViewController = UIViewController.alertViewController()
        alertViewController.isStatusBarHidden = true

        currentScreen = VFGRootViewController.shared.currentPage()
        alertViewController.loadViewIfNeeded()
        alertViewController.templateAlertContainerView.isHidden = true
        alertViewController.closeButton.isHidden = true
        alertViewController.titleLabel.isHidden = true
        alertViewController.isCampaign = isCampaign
        alertViewController.campaignId = campaignId
        alertViewController.shouldSendTags = shouldSendTags
        alertViewController.extraTags = extraTags

        let subViewConstraint = NSLayoutConstraint(item: alertViewController.configurableSubview,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: alertViewController.view,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: 0)
        alertViewController.view.addConstraint(subViewConstraint)

        let configurableSubview = subView
        alertViewController.configurableSubview.isHidden = false
        alertViewController.configurableSubview.clipsToBounds = true
        configurableSubview.frame = alertViewController.configurableSubview.bounds
        alertViewController.configurableSubview.addSubview(configurableSubview)

        return alertViewController
    }
}
