//
//  VFGAlertViewController+Events.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension VFGAlertViewController {

    func trackEventOfAlertViewed() {
        if !shouldSendTags {
            return
        }
        if isCampaign ?? false {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignView,
                                                   actionName: .interstitialViewed,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialCampaignOfferViewed,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   campaignId: campaignId,
                                                   event: .view,
                                                   extraTags: extraTags)
        } else {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageView,
                                                   actionName: .interstitialViewed,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageViewed,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   extraTags: extraTags)
        }
    }

    func trackPrimaryButtonClicked() {
        triggerTrackEvent(secondaryURL: primaryURL)
    }
    func trackSecondaryButtonClicked() {
        triggerTrackEvent(secondaryURL: secondaryURL)
    }

    func triggerTrackEvent(with primaryURL: String? = nil, secondaryURL: String? = nil) {

        var eventName: VFGAnalyticsEventName = .campaignClick
        var actionName: VFGAnalyticsEventActionKey = .interstitialClicked
        var eventLabel: VFGAnalyticsEventLabel = .interstitialCampaignOfferClicked
        var eventKey: VFGAnalyticsCampaignEventKey = .click
        var campaignId: String?

        if secondaryURL != nil {
            eventKey = .click
            actionName = .interstitialClicked
            if let isCampaign = isCampaign, isCampaign {
                eventName = .campaignClick
                eventLabel = .interstitialCampaignOfferClicked
                campaignId = self.campaignId
            } else {
                eventName = .messageClick
                actionName = .interstitialClicked
                eventLabel = .interstitialMessageClicked
            }
        } else {
            eventKey = .dismiss
            actionName = .interstitialDiscarded

            if let isCampaign = isCampaign, isCampaign {
                eventName = .campaignDismiss
                eventLabel = .interstitialCampaignOfferDismissed
                campaignId = self.campaignId
            } else {
                eventName = .messageDismiss
                eventLabel = .interstitialMessageDismissed
            }
        }

        VFGAnalyticsHandler.commonUITrackEvent(eventName: eventName,
                                               actionName: actionName,
                                               categoryName: .interstitial,
                                               eventLabel: eventLabel,
                                               pageName: VFGAlertViewController.currentScreen,
                                               campaignId: campaignId,
                                               event: eventKey,
                                               extraTags: extraTags)

    }
    func trackEventOfAlertClicked() {
        if !shouldSendTags {
            return
        }
        if let isCampaign = isCampaign, isCampaign {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignClick,
                                                   actionName: .interstitialClicked,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialCampaignOfferClicked,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   campaignId: campaignId,
                                                   event: .click,
                                                   extraTags: extraTags)
        } else {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageClick,
                                                   actionName: .interstitialClicked,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageClicked,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   extraTags: extraTags)
        }
    }

    func trackEventOfAlertDismissed() {
        if !shouldSendTags {
            return
        }
        if let isCampaign = isCampaign, isCampaign {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignDismiss,
                                                   actionName: .interstitialDiscarded,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialCampaignOfferDismissed,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   campaignId: campaignId,
                                                   event: .dismiss,
                                                   extraTags: extraTags)
        } else {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageDismiss,
                                                   actionName: .interstitialDiscarded,
                                                   categoryName: .interstitial,
                                                   eventLabel: .interstitialMessageDismissed,
                                                   pageName: VFGAlertViewController.currentScreen,
                                                   extraTags: extraTags)
        }
    }

}
