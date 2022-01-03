//
//  VFGAlertViewController+Show.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension VFGAlertViewController {

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlert(title alertTitle: String?,
                                       alertMessage: String,
                                       alertSubmessage: String = "",
                                       primaryButtonText: String,
                                       primaryButtonAction: (() -> Void)?,
                                       secondaryButtonText: String? = nil,
                                       secondaryButtonAction: (() -> Void)? = nil,
                                       tertiaryButtonText: String? = nil,
                                       tertiaryButtonAction: (() -> Void)? = nil,
                                       closeButtonAction: (() -> Void)? = nil,
                                       icon: UIImage?) {

        VFGAlertViewController.showAlert(title: alertTitle,
                                         alertMessage: alertMessage,
                                         alertSubmessage: alertSubmessage,
                                         primaryButtonText: primaryButtonText,
                                         primaryButtonAction: primaryButtonAction,
                                         secondaryButtonText: secondaryButtonText,
                                         secondaryButtonAction: secondaryButtonAction,
                                         tertiaryButtonText: tertiaryButtonText,
                                         tertiaryButtonAction: tertiaryButtonAction,
                                         closeButtonAction: closeButtonAction,
                                         icon: icon, isCampaign: false,
                                         campaignId: nil)
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlertWithSubView(title titleString: String?,
                                                  view subview: UIView?,
                                                  showCloseButton closeButtonVisible: Bool,
                                                  closeButtonAction: (() -> Void)? = nil) {

        VFGAlertViewController.showAlertWithSubView(title: titleString,
                                                    view: subview,
                                                    showCloseButton: closeButtonVisible,
                                                    closeButtonAction: closeButtonAction,
                                                    isCampaign: false,
                                                    campaignId: nil)
    }

    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlertWithSubView(view subView: UIView) {
        VFGAlertViewController.showAlertWithSubView(view: subView,
                                                    isCampaign: false,
                                                    campaignId: nil)
    }

    /*
     This method displays full screen alert view controller with three buttons.
     This screen will be automatically dismissed after closure execution

      parameter alertTitle: alert view title, can be nil.
      parameter alertMessage: main alert message
      parameter alertSubmessage : optional ert sub message
      parameter primaryButtonText: primary button text
      parameter primaryButtonAction: closure with primary button action
      parameter secondaryButtonText: optional secondary button text
      parameter secondaryButtonAction: optional closure with secondary button action
      parameter tertiaryButtonText: optional tertiary button text
      parameter tertiaryButtonAction: optional clousure with tertiary button action
      parameter icon: optional icon image to be displayed
     */
    //Should be deprecatted soon
    @available(*, deprecated, renamed: "showAlert(with:)")
    @objc static public func showAlert(title alertTitle: String?,
                                       alertMessage: String,
                                       alertSubmessage: String = "",
                                       primaryButtonText: String,
                                       primaryButtonAction: (() -> Void)?,
                                       secondaryButtonText: String? = nil,
                                       secondaryButtonAction: (() -> Void)? = nil,
                                       tertiaryButtonText: String? = nil,
                                       tertiaryButtonAction: (() -> Void)? = nil,
                                       closeButtonAction: (() -> Void)? = nil,
                                       icon: UIImage?,
                                       isCampaign: Bool = false,
                                       campaignId: String? = nil,
                                       shouldSendTags: Bool = true) {
        let alertViewController = UIViewController.alertViewController()
        currentScreen = VFGRootViewController.shared.currentPage()
        alertViewController.loadViewIfNeeded()
        alertViewController.closeButton.isHidden = false
        alertViewController.titleLabel.text =  alertTitle
        alertViewController.messageLabel.attributedText = NSAttributedString(with: alertMessage,
                                                                             and: alertSubmessage)
        alertViewController.primaryButton.setTitle(primaryButtonText, for: .normal)
        alertViewController.primaryButtonAction = primaryButtonAction
        alertViewController.isCampaign = isCampaign
        alertViewController.campaignId = campaignId
        alertViewController.shouldSendTags = shouldSendTags

        if secondaryButtonText == nil || secondaryButtonText!.isEmpty {
            alertViewController.secondaryButton.isHidden = true
            alertViewController.secondaryButtonView.isHidden = true
        } else {
            alertViewController.secondaryButton.setTitle(secondaryButtonText, for: .normal)
            alertViewController.secondaryButtonAction = secondaryButtonAction
        }

        if tertiaryButtonText == nil || tertiaryButtonText!.isEmpty {
            alertViewController.tertiaryButton.isHidden = true
            alertViewController.tertiaryButtonView.isHidden = true
        } else {
            alertViewController.tertiaryButton.setTitle(tertiaryButtonText, for: .normal)
            alertViewController.tertiaryButtonAction = tertiaryButtonAction
        }
        alertViewController.closeButtonAction = closeButtonAction
        alertViewController.icon.image = icon
        presentOnTop(viewController: alertViewController) {
            alertViewController.trackEventOfAlertViewed()
        }
    }

    @objc static public func showAlertWithSubView(
        title titleString: String?,
        view subview: UIView?,
        showCloseButton closeButtonVisible: Bool,
        closeButtonAction: (() -> Void)? = nil,
        isCampaign: Bool = false,
        campaignId: String? = nil,
        shouldSendTags: Bool = true) {
        let alertViewController = setupAlertview(titleString: titleString,
                                                 subview: subview,
                                                 closeButtonVisible: closeButtonVisible,
                                                 closeButtonAction: closeButtonAction,
                                                 isCampaign: isCampaign,
                                                 campaignId: campaignId,
                                                 shouldSendTags: shouldSendTags)
        presentOnTop(viewController: alertViewController) {
            alertViewController.trackEventOfAlertViewed()
        }
    }

    @objc static public func showAlertWithSubView(
        view subView: UIView,
        isCampaign: Bool = false,
        campaignId: String? = nil,
        shouldSendTags: Bool = true) {

        let alertViewController = setupAlertview(view: subView,
                                                 isCampaign: isCampaign,
                                                 campaignId: campaignId,
                                                 shouldSendTags: shouldSendTags)
        presentOnTop(viewController: alertViewController) {
            alertViewController.trackEventOfAlertViewed()
        }
    }

    @objc private static func presentOnTop(viewController presentedVC: UIViewController,
                                           completionHandler: @escaping () -> Void) {

        let alert = presentedVC
        let window = UIApplication.shared.keyWindow
        let topVC = UIApplication.shared.topMostViewController
        window?.windowLevel = UIWindow.Level.statusBar - 1
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            alert.modalPresentationStyle = .overFullScreen
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                alert.modalPresentationStyle = .popover
            } else {
                alert.modalPresentationStyle = .overCurrentContext
            }
        }
        topVC?.present(alert, animated: true, completion: {
            completionHandler()
        })
    }
}
