//
//  VFGAlertViewController.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 15.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc public class VFGAlertViewController: UIViewController, UIScrollViewDelegate {
    @objc static public let connectionErrorAlertTitle: String = "commonui_connection_error_alert_title".localized
    @objc static public let connectionErrorAlertMessage: String = "commonui_connection_error_alert_message".localized
    @objc static public let connectionErrorAlertOkTitle: String = "commonui_connection_error_alert_ok_button".localized

    static private let closeImage: String = "close"
    static var currentScreen: String = ""
    var isCampaign: Bool?
    public var isStatusBarHidden: Bool = false {
        didSet(newValue) {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var campaignId: String?
    var shouldSendTags: Bool = true
    var extraTags: [String: String]?
    @IBOutlet weak var alertScrollView: UIScrollView!
    @IBOutlet weak var templateAlertContainerView: UIView!
    @IBOutlet weak var configurableSubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var tertiaryButton: UIButton!

    @IBOutlet weak var primaryButtonView: UIView!
    @IBOutlet weak var secondaryButtonView: UIView!
    @IBOutlet weak var tertiaryButtonView: UIView!

    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!

    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var titleLabelHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var stackView: UIStackView!
    internal var primaryButtonAction : (() -> Void)?
    internal var secondaryButtonAction : (() -> Void)?
    internal var tertiaryButtonAction : (() -> Void)?
    internal var closeButtonAction : (() -> Void)?
    internal var primaryURL: String?
    internal var secondaryURL: String?

    private let fadeInOutAnimationTime: TimeInterval = 0.17
    static let upwardsAnimationKey: String = "moveUpwards"
    static let downwardsAnimationKey: String = "moveDownwards"
    static let fadeAnimationKey: String = "fade"
    private var gradient: CAGradientLayer!
    private var lastContentOffset: CGFloat = 0

    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        alertScrollView.delegate = self
        if !UIScreen.isIpad {
            closeButton.tintColor = UIColor.white
            let closeButtonImage = UIImage(fromCommonUINamed: VFGAlertViewController.closeImage)
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate),
                                 for: .normal)
            closeButton.imageView?.contentMode = .scaleAspectFit
        }
    }

    @objc public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fadingView.backgroundColor = UIColor.VFGOverlayBackground
        slidingView.backgroundColor = UIColor.VFGOverlayBackground
        view.backgroundColor = UIColor.clear

        primaryButton.setPrimaryStyle()

        if !secondaryButton.isHidden {
            secondaryButton.setSecondaryStyle()
        }

        if !tertiaryButton.isHidden {
            tertiaryButton.setTertiaryStyle()
        }

        if animated {
            titleLabel.alpha = 0
            closeButton.alpha = 0
            view.layoutIfNeeded()

            icon.layer.add(slideAnimation(upwards: true, for: icon),
                           forKey: VFGAlertViewController.upwardsAnimationKey)
            messageLabel.layer.add(slideAnimation(upwards: true, for: messageLabel),
                                   forKey: VFGAlertViewController.upwardsAnimationKey)
            primaryButton.layer.add(slideAnimation(upwards: true, for: primaryButton),
                                    forKey: VFGAlertViewController.upwardsAnimationKey)
            slidingView.layer.add(slideAnimation(upwards: true, for: slidingView),
                                  forKey: VFGAlertViewController.upwardsAnimationKey)
            fadingView.layer.add(alphaAnimation(toVisible: true),
                                 forKey: VFGAlertViewController.fadeAnimationKey)

            if !secondaryButton.isHidden {
                secondaryButton.layer.add(slideAnimation(upwards: true, for: secondaryButton),
                                          forKey: VFGAlertViewController.upwardsAnimationKey)
            }

            if !tertiaryButton.isHidden {
                tertiaryButton.layer.add(slideAnimation(upwards: true, for: tertiaryButton),
                                         forKey: VFGAlertViewController.upwardsAnimationKey)
            }

            UIView.animate(withDuration: fadeInOutAnimationTime, delay: 0, options: .curveLinear, animations: {
                self.titleLabel.alpha = 1
                self.closeButton.alpha = 1
            })
        }

    }

    @IBAction func primaryButtonTapped(_ sender: AnyObject) {
        dismissWithAnimation {
            self.primaryButtonAction?()
            self.trackPrimaryButtonClicked()
        }
    }

    @IBAction func secondaryButtonTapped(_ sender: AnyObject) {
        dismissWithAnimation {
            self.secondaryButtonAction?()
            self.trackSecondaryButtonClicked()
        }
    }

    @IBAction func tertiaryButtonTapped(_ sender: AnyObject) {
        dismissWithAnimation {
            self.tertiaryButtonAction?()
            self.trackEventOfAlertClicked()
        }
    }

    func dismissWithAnimation(_ completionBlock:(() -> Swift.Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionBlock)

        view.isUserInteractionEnabled = false

        icon.layer.add(slideAnimation(upwards: false,
                                      for: icon),
                       forKey: VFGAlertViewController.downwardsAnimationKey)
        messageLabel.layer.add(slideAnimation(upwards: false,
                                              for: messageLabel),
                               forKey: VFGAlertViewController.downwardsAnimationKey)
        primaryButton.layer.add(slideAnimation(upwards: false,
                                               for: primaryButton),
                                forKey: VFGAlertViewController.downwardsAnimationKey)
        slidingView.layer.add(slideAnimation(upwards: false,
                                             for: slidingView),
                              forKey: VFGAlertViewController.downwardsAnimationKey)

        if let configView: UIView = configurableSubview {
            configView.layer.add(slideAnimation(upwards: false,
                                                for: configView),
                                 forKey: VFGAlertViewController.downwardsAnimationKey)
        }

        if !secondaryButton.isHidden {
            secondaryButton.layer.add(slideAnimation(upwards: false,
                                                     for: secondaryButton),
                                      forKey: VFGAlertViewController.downwardsAnimationKey)
        }

        if !tertiaryButton.isHidden {
            tertiaryButton.layer.add(slideAnimation(upwards: false,
                                                    for: tertiaryButton),
                                     forKey: VFGAlertViewController.downwardsAnimationKey)
        }

        UIView.animate(withDuration: fadeInOutAnimationTime, delay: 0, options: .curveLinear, animations: {
            self.titleLabel.alpha = 0
            self.closeButton.alpha = 0
            self.messageLabel.alpha = 0
        })

        fadingView.layer.add(alphaAnimation(toVisible: false), forKey: VFGAlertViewController.fadeAnimationKey)
        //Make the UI responsive earlier to avoid "dismiss lag"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: false, completion: nil)
        }
        CATransaction.commit()
    }

    @IBAction func closeAction(_ sender: Any) {
        dismissWithAnimation {
            self.isStatusBarHidden = true
            if self.closeButtonAction != nil {
                self.closeButtonAction!()
            }
            self.trackEventOfAlertDismissed()
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // increase scroll height for long messages
        if lastContentOffset > scrollView.contentOffset.y {
            changeGradientScrollEffect(scrollView: scrollView, isDirectionToTop: false)
        }
            // check if user scrolls from bottom to top
        else if lastContentOffset < scrollView.contentOffset.y {
            changeGradientScrollEffect(scrollView: scrollView, isDirectionToTop: true)
        }
    }

    func changeGradientScrollEffect(scrollView: UIScrollView, isDirectionToTop: Bool) {
        gradient = CAGradientLayer()
        if isDirectionToTop {
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor,
                               UIColor.black.cgColor, UIColor.black.cgColor]
            gradient.locations = [0, 0.15, 0.85, 1]
            scrollView.layer.mask = gradient
            gradient.frame = CGRect(
                x: 0,
                y: scrollView.contentOffset.y,
                width: scrollView.bounds.width,
                height: scrollView.bounds.height
            )
        } else {
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 0.1, 1.0]
            scrollView.layer.mask = gradient
            gradient.frame = CGRect(
                x: 0,
                y: scrollView.contentOffset.y,
                width: scrollView.bounds.width,
                height: scrollView.bounds.height
            )
        }
    }

    public override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
}
