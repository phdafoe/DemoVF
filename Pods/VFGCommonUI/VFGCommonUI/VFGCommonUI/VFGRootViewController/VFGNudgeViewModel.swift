//
//  NudgeViewModel.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGNudgeViewModel: NSObject {

    let title: String?
    let nudgeDescription: String
    let shouldSendTags: Bool
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?
    let primaryButtonAction: (() -> Void)?
    let secondaryButtonAction:(() -> Void)?
    let closeAction:(() -> Void)?
    let isCampaign: Bool
    let campaignId: String?
    let extraTags: [String: String]
    let primaryURL: String?
    let secondaryURL: String?

    public init(title: String? = nil,
                nudgeDescription: String = "",
                shouldSendTags: Bool = false,
                primaryButtonTitle: String? = nil,
                secondaryButtonTitle: String? = nil,
                primaryButtonAction: (() -> Void)? = nil,
                secondaryButtonAction:(() -> Void)? = nil,
                closeAction:(() -> Void)? = nil,
                isCampaign: Bool = false,
                campaignId: String? = nil,
                primaryURL: String? = nil,
                secondaryURL: String? = nil,
                extraTags: [String: String] = [:]) {

        self.title = title
        self.nudgeDescription = nudgeDescription
        self.shouldSendTags = shouldSendTags
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.closeAction = closeAction
        self.isCampaign = isCampaign
        self.campaignId = campaignId
        self.primaryURL = primaryURL
        self.secondaryURL = secondaryURL
        self.extraTags = extraTags
    }
}
