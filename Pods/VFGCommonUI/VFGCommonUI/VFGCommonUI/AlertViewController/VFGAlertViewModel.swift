//
//  VFGAlertViewModel.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGAlertViewModel: NSObject {
    let alertTitle: String
    let alertMessage: String
    let alertSubmessage: String
    let primaryButtonText: String
    let primaryButtonAction: (() -> Void)?
    let secondaryButtonText: String
    let secondaryButtonAction: (() -> Void)?
    let tertiaryButtonText: String
    let tertiaryButtonAction: (() -> Void)?
    let closeButtonAction: (() -> Void)?
    let icon: UIImage?
    let closeButtonVisible: Bool
    let isCampaign: Bool
    let campaignId: String
    let shouldSendTags: Bool
    let extraTags: [String: String]
    let primaryURL: String?
    let secondaryURL: String?

    @objc public init(alertTitle: String = "",
                      alertMessage: String = "",
                      alertSubmessage: String = "",
                      primaryButtonText: String = "",
                      primaryButtonAction: (() -> Void)? = nil,
                      secondaryButtonText: String = "",
                      secondaryButtonAction: (() -> Void)? = nil,
                      tertiaryButtonText: String = "",
                      tertiaryButtonAction: (() -> Void)? = nil,
                      closeButtonAction: (() -> Void)? = nil,
                      icon: UIImage? = nil,
                      closeButtonVisible: Bool = true,
                      isCampaign: Bool = false,
                      campaignId: String = "",
                      shouldSendTags: Bool = false,
                      extraTags: [String: String] = [:],
                      primaryURL: String? = nil,
                      secondaryURL: String? = nil) {

        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.alertSubmessage = alertSubmessage
        self.primaryButtonText = primaryButtonText
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonText = secondaryButtonText
        self.secondaryButtonAction = secondaryButtonAction
        self.tertiaryButtonText = tertiaryButtonText
        self.tertiaryButtonAction = tertiaryButtonAction
        self.closeButtonAction = closeButtonAction
        self.icon = icon
        self.closeButtonVisible = closeButtonVisible
        self.isCampaign = isCampaign
        self.campaignId = campaignId
        self.shouldSendTags = shouldSendTags
        self.extraTags = extraTags
        self.primaryURL = primaryURL
        self.secondaryURL = secondaryURL
    }
}
