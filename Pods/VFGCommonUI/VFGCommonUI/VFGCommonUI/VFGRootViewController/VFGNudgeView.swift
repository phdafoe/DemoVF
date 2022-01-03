//
//  VFGNudgeView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 11/15/17.
//

import UIKit
import VFGCommonUtils

class VFGNudgeView: UIView {

    var currentHeight: CGFloat {
        return containerView.bounds.size.height
    }
    var closeButtonAction: (() -> Void)?
    private var primaryButtonAction: (() -> Void)?
    private var secondaryButtonAction: (() -> Void)?
    private var isCampaign: Bool?
    private var campaignId: String?
    private var currentScreen: String = ""
    private var primaryURL: String?
    private var secondaryURL: String?
    private var extraTags: [String: String]?
    @IBOutlet weak var secondryButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var width: NSLayoutConstraint!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var primaryButton: UIButton!
    @IBOutlet weak private var secondaryButton: UIButton!
    @IBOutlet weak private var verticalSpacePrimaryAndSecondaryButton: NSLayoutConstraint!
    @IBOutlet weak private var primaryButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var secondaryButtonLeftConstraint: NSLayoutConstraint!
    private let numberOflines: Int = 4
    private let nibName: String = "VFGNudgeView"
    private let titleMinimumFontSize = 26
    private let closeButtonImageHeight = 24
    private let verticalSpacingCloseButtonAndTitle = 8
    private let verticalSpacingCloseButtonAndTopValue: CGFloat = 15
    internal var willDisappear: Bool = false
    //constraints for close button spacing from top of the view, iPhone X support
    @IBOutlet weak var closeWhiteImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopSpaceHeightConstraint: NSLayoutConstraint!

    func setup(title: String? = "",
               description: String,
               primaryButtonTitle: String? = "",
               secondaryButtonTitle: String? = "",
               primaryButtonAction: (() -> Void)?,
               secondaryButtonAction: (() -> Void)?,
               campaign: Bool? = false,
               campaignId: String? = nil,
               primaryURL: String? = nil,
               secondaryURL: String? = nil,
               extraTags: [String: String]? = nil) {

        initializeTitles(title: title, description: description)
        if descriptionLabel.numberOfVisibleLines > numberOflines {
            descriptionLabel.numberOfLines = numberOflines
        }
        containerView.layoutIfNeeded()

        if !(primaryButtonTitle ?? "").isEmpty, !(secondaryButtonTitle ?? "").isEmpty {
            verticalSpacePrimaryAndSecondaryButton.priority = .high
            primaryButtonRightConstraint.priority = .low
            secondaryButtonLeftConstraint.priority = .low
            self.primaryButtonAction = primaryButtonAction
            self.secondaryButtonAction = secondaryButtonAction
        } else if primaryButtonTitle?.count != 0, primaryButtonTitle != nil {
            primaryButtonRightConstraint.priority = .high
            secondaryButtonLeftConstraint.priority = .low
            verticalSpacePrimaryAndSecondaryButton.priority = .low
            self.primaryButtonAction = primaryButtonAction
        } else if secondaryButtonTitle?.count != 0 && secondaryButtonTitle != nil {
            verticalSpacePrimaryAndSecondaryButton.priority = .low
            primaryButtonRightConstraint.priority = .low
            secondaryButtonLeftConstraint.priority = .high
            self.secondaryButtonAction = secondaryButtonAction
        } else {
            secondaryButton.isHidden = true
            primaryButton.isHidden = true
            secondryButtonHeightConstraint.constant = 0
        }
        primaryButton.setTitle(primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        isCampaign = campaign
        self.campaignId = campaignId
        self.primaryURL = primaryURL
        self.secondaryURL = secondaryURL
        self.extraTags = extraTags
        currentScreen = VFGRootViewController.shared.currentPage()
        adjustCloseButtonConstraints()
        containerView.layoutIfNeeded()
    }

    private func initializeTitles(title: String?, description: String) {
        titleLabel.text = title ?? ""
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.vodafoneLiteRegularFont(30)
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.vodafoneLiteRegularFont(20)
        primaryButton.titleLabel?.font = UIFont.vodafoneRegularFont(18)
        secondaryButton.titleLabel?.font = UIFont.vodafoneRegularFont(18)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }

    @IBAction private func closeButtonPressed(_ sender: UIButton) {
        VFGRootViewController.shared.shouldNudgeView = false
        closeButtonAction?()
        if let isCampaign = isCampaign, isCampaign {
            trackCampaignDismissed()
        } else {
            trackMessageDismissed()
        }
    }
    @IBAction private func primaryButtonPressed(_ sender: UIButton) {
        VFGRootViewController.shared.shouldNudgeView = false
        primaryButtonAction?()
        if let isCampaign = isCampaign, isCampaign {
            if secondaryButton.currentTitle?.isEmpty ?? true {
                trackCampaignDismissed()
            } else {
                trackCampaignClicked()
            }
        } else {
            if secondaryButton.currentTitle?.isEmpty ?? true {
                trackMessageDismissed()
            } else {
                trackMessageClicked()
            }
        }
    }

    @IBAction private func secondaryButtonPressed(_ sender: UIButton) {
        VFGRootViewController.shared.shouldNudgeView = false
        secondaryButtonAction?()
        if let isCampaign = isCampaign, isCampaign {
            if secondaryURL != nil {
                trackCampaignClicked()
            } else {
                trackCampaignDismissed()
            }
        } else {
            if secondaryURL != nil {
                trackMessageClicked()
            } else {
                trackMessageDismissed()
            }
        }
    }

    private func trackMessageDismissed() {
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageDismiss,
                                               actionName: .nudgeDismissed,
                                               categoryName: .nudge,
                                               eventLabel: .nudgeMessageDismissed,
                                               pageName: currentScreen,
                                               extraTags: extraTags)
    }

    private func trackCampaignDismissed() {
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignDismiss,
                                               actionName: .nudgeDismissed,
                                               categoryName: .nudge,
                                               eventLabel: .nudgeCampaignOfferDismissed,
                                               pageName: currentScreen,
                                               campaignId: campaignId,
                                               extraTags: extraTags)
    }

    private func trackMessageClicked() {
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageClick,
                                               actionName: .nudgeClicked,
                                               categoryName: .nudge,
                                               eventLabel: .nudgeMessageClicked,
                                               pageName: currentScreen,
                                               extraTags: extraTags)
    }

    private func trackCampaignClicked() {
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignClick,
                                               actionName: .nudgeClicked,
                                               categoryName: .nudge,
                                               eventLabel: .nudgeCampaignOfferClicked,
                                               pageName: currentScreen,
                                               campaignId: campaignId,
                                               extraTags: extraTags)
    }

    private func loadFromNib() {
        if let contentView: UIView = Bundle.vfgCommonUI.loadNibNamed(nibName,
                                                                     owner: self,
                                                                     options: nil)?.first as? UIView {
            contentView.frame = bounds
            addSubview(contentView)
            layoutIfNeeded()
            width.constant = UIScreen.main.bounds.size.width
        }
    }

    internal func adjustCloseButtonConstraints() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        if UIScreen.hasNotch {
            closeWhiteImageTopConstraint.constant = verticalSpacingCloseButtonAndTopValue + (statusBarHeight - 10)
        } else {
            closeWhiteImageTopConstraint.constant = verticalSpacingCloseButtonAndTopValue + statusBarHeight
        }
        closeButtonTopConstraint.constant = closeWhiteImageTopConstraint.constant
        titleLabelTopSpaceHeightConstraint.constant = closeButtonTopConstraint.constant +
            CGFloat(closeButtonImageHeight + verticalSpacingCloseButtonAndTitle)
    }
}

fileprivate extension UILabel {

    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(font.pointSize))
        return rHeight / charSize
    }

}
