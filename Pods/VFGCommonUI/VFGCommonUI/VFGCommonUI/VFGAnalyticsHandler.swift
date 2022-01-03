//
//  VFGAnalyticsHandler.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 10/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

private enum VFGAnalyticsEventKey: String {
    case action = "event_action"
    case category = "event_category"
    case label = "event_label"
    case value = "event_value"
    case pageName = "page_name"
    case pageNameNext = "page_name_next"
    case instance = "event_instance"
    case campaignId = "campaign_id"
    case event = "event"
    case messageID = "message_id"
    case campaignContent = "campaign_content"
    case campaignDateExpiryTimestamp = "campaign_date_expiry_timestamp"
    case campaignDateLaunchInitial = "campaign_date_launch_initial"
    case campaignDateLaunchLatest = "campaign_date_launch_latest"
    case campaignExpiration = "campaign_expiration"
    case campaignFrequency = "campaign_frequency"
    case campaignJourneyPhase = "campaign_journey_phase"
    case campaignMedium = "campaign_medium"
    case campaignName = "campaign_name"
    case campaignSource = "campaign_source"
    case campaignTerm = "campaign_term"
    case campaignVisitorType = "campaign_visitor_type"
}

enum MessageVariableKeys: String {
    case messageId = "message_id"
    case messageContent = "message_content"
}

internal enum VFGAnalyticsEventName: String {
    case messageView = "message_view"
    case messageClick = "message_click"
    case messageDismiss = "message_dismiss"
    case uiInteraction = "ui_interaction"
    case messageReceived = "message_receive"
    case campaignClick = "campaign_click"
    case campaignDismiss = "campaign_dismiss"
    case campaignView = "campaign_view"
    case campaignReceive = "campaign_receive"
}

internal enum VFGAnalyticsEventLabel: String {
    case sideMenuClick = "Side Menu - Click" //Done
    case nudgeMessageViewed = "Nudge UI - Message Viewed" //Done
    case nudgeMessageReceived = "Nudge UI - Message Received" //Done
    case nudgeCampaignOfferViewed = "Nudge UI - Campaign Offer Viewed" //Done
    case nudgeCampaignOfferReceived = "Nudge UI - Campaign Offer Received" //Done
    case nudgeMessageClicked = "Nudge UI - Message Clicked" //Done
    case nudgeCampaignOfferClicked = "Nudge UI - Campaign Offer Clicked" //Done
    case nudgeMessageDismissed = "Nudge UI - Message Dismissed" //Done
    case nudgeCampaignOfferDismissed = "Nudge UI - Campaign Offer Dismissed" //Done
    case interstitialMessageViewed = "Interstitial UI - Message Viewed"
    case interstitialCampaignOfferViewed = "Interstitial UI - Campaign Offer Viewed"
    case interstitialMessageClicked = "Interstitial UI - Message Clicked"
    case interstitialCampaignOfferClicked = "Interstitial UI - Campaign Offer Clicked"
    case interstitialMessageDismissed = "Interstitial UI - Message Dismissed"
    case interstitialCampaignOfferDismissed = "Interstitial UI - Campaign Offer Dismissed"
    case interstitialUICampaignOfferReceived = "Interstitial UI - Campaign Offer Received"
    case toastMessageViewed = "Toast UI - Message Viewed" //Done
}

internal enum VFGAnalyticsEventActionKey: String {
    case nudgeViewed = "nudge viewed"
    case nudgeReceived = "nudge received"
    case nudgeClicked = "nudge clicked"
    case nudgeDismissed = "nudge dismissed"
    case interstitialViewed = "interstitial viewed"
    case interstitialDiscarded = "interstitial discarded"
    case interstitialClicked = "interstitial clicked"
    case interstitialReceived = "interstitial received"
    case toastViewed = "toast viewed"
    case menuClick = "menu click"
}

internal enum VFGAnalyticsEventCategoryKey: String {
    case nudge = "nudge message"
    case interstitial = "interstitial message"
    case toast = "toast message"
    case uiInteractions = "ui interactions"
}

internal enum VFGAnalyticsCampaignEventKey: String {
    case click = "campaign_click"
    case dismiss = "campaign_dismiss"
    case view = "campaign_view"
    case receive = "campaign_receive"
}
internal struct VFGAnalyticsHandler {

    static func trackEventForFloatingBubbleClick() {
        let trackEventDec: [String: String] = [
            VFGAnalyticsEventKey.action.rawValue: "Button Click" ,
            VFGAnalyticsEventKey.category.rawValue: "UI Interactions" ,
            VFGAnalyticsEventKey.label.rawValue: "Need Help?",
            VFGAnalyticsEventKey.value.rawValue: "1",
            VFGAnalyticsEventKey.pageName.rawValue: "Dashboard",
            VFGAnalyticsEventKey.pageNameNext.rawValue: "FAQs"
        ]
       VFGAnalytics.trackEvent(VFGAnalyticsEventKey.instance.rawValue,
                               dataSources: trackEventDec)
    }

    static func commonUITrackEvent(eventName: VFGAnalyticsEventName,
                                   actionName: VFGAnalyticsEventActionKey,
                                   categoryName: VFGAnalyticsEventCategoryKey,
                                   eventLabel: VFGAnalyticsEventLabel,
                                   pageName: String,
                                   nextPageName: String = "",
                                   campaignId: String? = nil,
                                   messageId: String? = nil,
                                   event: VFGAnalyticsCampaignEventKey? = nil,
                                   extraTags: [String: String]? = nil) {
        var trackEventDic: [String: String] = [
            VFGAnalyticsEventKey.action.rawValue: actionName.rawValue ,
            VFGAnalyticsEventKey.category.rawValue: categoryName.rawValue ,
            VFGAnalyticsEventKey.label.rawValue: eventLabel.rawValue ,
            VFGAnalyticsEventKey.pageName.rawValue: pageName,
            VFGAnalyticsEventKey.pageNameNext.rawValue: nextPageName
        ]
        if let extraTags = extraTags {
            trackEventDic = trackEventDic.merging(extraTags) {$1}
        }
        if let campaignId = campaignId {
            trackEventDic[VFGAnalyticsEventKey.campaignId.rawValue] = campaignId
        }
        if let event = event?.rawValue {
            trackEventDic[VFGAnalyticsEventKey.event.rawValue] = event
        }
        VFGAnalytics.trackEvent(eventName.rawValue, dataSources: trackEventDic)
    }

    public static func extractExraTags() -> [String: String] {
        let trackViewDec: [String: String] = [
            VFGAnalyticsEventKey.campaignContent.rawValue: "",
            VFGAnalyticsEventKey.campaignDateExpiryTimestamp.rawValue: "",
            VFGAnalyticsEventKey.campaignDateLaunchInitial.rawValue: "",
            VFGAnalyticsEventKey.campaignDateLaunchLatest.rawValue: "",
            VFGAnalyticsEventKey.campaignExpiration.rawValue: "",
            VFGAnalyticsEventKey.campaignFrequency.rawValue: "",
            VFGAnalyticsEventKey.campaignJourneyPhase.rawValue: "",
            VFGAnalyticsEventKey.campaignMedium.rawValue: "",
            VFGAnalyticsEventKey.campaignName.rawValue: "",
            VFGAnalyticsEventKey.campaignSource.rawValue: "",
            VFGAnalyticsEventKey.campaignTerm.rawValue: "",
            VFGAnalyticsEventKey.campaignVisitorType.rawValue: ""
        ]
        return trackViewDec
    }

}
