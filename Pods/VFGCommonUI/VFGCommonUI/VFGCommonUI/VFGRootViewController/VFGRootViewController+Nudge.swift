//
//  VFGRootViewController+Nudge.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 29/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension VFGRootViewController {

    @objc public func showNudge(with viewModel: VFGNudgeViewModel) {
        nudgeView.setup(title: viewModel.title,
                        description: viewModel.nudgeDescription,
                        primaryButtonTitle: viewModel.primaryButtonTitle,
                        secondaryButtonTitle: viewModel.secondaryButtonTitle,
                        primaryButtonAction: viewModel.primaryButtonAction,
                        secondaryButtonAction: viewModel.secondaryButtonAction,
                        campaign: viewModel.isCampaign,
                        campaignId: viewModel.campaignId,
                        primaryURL: viewModel.primaryURL,
                        secondaryURL: viewModel.secondaryURL,
                        extraTags: viewModel.extraTags)

        nudgeView.closeButtonAction = viewModel.closeAction
        showNudge()
        sendNudgeTags(campaignId: viewModel.campaignId,
                      isCampaign: viewModel.isCampaign,
                      extraTags: viewModel.extraTags)
    }

    /**
     Show Nudge View with Data
     @param title Optinal String, title of Nudge view
     @param description String, description of Nudge view
     @param primaryButtonTitle String, primary Button Title of Nudge view
     @param secondaryButtonTitle String, secondary Button Title of Nudge view
     @param primaryButtonAction Optinal callback, primary Button Action of Nudge view
     @param secondaryButtonAction Optinal callback, secondary Button Action of Nudge view
     @param closeAction Optinal callback, close Action of Nudge view
     */

    @available(*, deprecated, renamed: "showNudge(with:)")
    @objc public func showNudgeView(title: String? = "",
                                    description: String,
                                    shouldSendTags: Bool = true,
                                    primaryButtonTitle: String? = "",
                                    secondaryButtonTitle: String? = "",
                                    primaryButtonAction: (() -> Void)?,
                                    secondaryButtonAction:(() -> Void)?,
                                    closeAction: @escaping () -> Void) {
        nudgeView.setup(title: title,
                        description: description,
                        primaryButtonTitle: primaryButtonTitle,
                        secondaryButtonTitle: secondaryButtonTitle,
                        primaryButtonAction: primaryButtonAction,
                        secondaryButtonAction: secondaryButtonAction)

        nudgeView.closeButtonAction = closeAction
        showNudge()
        VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageView,
                                               actionName: .nudgeViewed,
                                               categoryName: .nudge,
                                               eventLabel: .nudgeMessageViewed,
                                               pageName: currentPage())
    }

    @available(*, deprecated, renamed: "showNudge(with:)")
    @objc public func showNudgeView(title: String? = "",
                                    description: String,
                                    primaryButtonTitle: String? = "",
                                    secondaryButtonTitle: String? = "",
                                    primaryButtonAction: (() -> Void)?,
                                    secondaryButtonAction:(() -> Void)?,
                                    closeAction: @escaping () -> Void,
                                    isCampaign: Bool,
                                    campaignId: String? = nil,
                                    extraTags: [String: String]? = nil) {
        nudgeView.setup(title: title,
                        description: description,
                        primaryButtonTitle: primaryButtonTitle,
                        secondaryButtonTitle: secondaryButtonTitle,
                        primaryButtonAction: primaryButtonAction,
                        secondaryButtonAction: secondaryButtonAction,
                        campaign: isCampaign,
                        campaignId: campaignId)

        nudgeView.closeButtonAction = closeAction
        showNudge()
        sendNudgeTags(campaignId: campaignId, isCampaign: isCampaign, extraTags: extraTags)
    }

    @available(*, deprecated, renamed: "showNudge(with:)")
    @objc public func showNudgeView(title: String? = "",
                                    description: String,
                                    primaryButtonTitle: String? = "",
                                    secondaryButtonTitle: String? = "",
                                    primaryButtonAction: (() -> Void)?,
                                    secondaryButtonAction:(() -> Void)?,
                                    closeAction: @escaping () -> Void,
                                    isCampaign: Bool,
                                    campaignId: String? = nil) {
        nudgeView.setup(title: title,
                        description: description,
                        primaryButtonTitle: primaryButtonTitle,
                        secondaryButtonTitle: secondaryButtonTitle,
                        primaryButtonAction: primaryButtonAction,
                        secondaryButtonAction: secondaryButtonAction,
                        campaign: isCampaign,
                        campaignId: campaignId)

        nudgeView.closeButtonAction = closeAction
        showNudge()
        sendNudgeTags(campaignId: campaignId, isCampaign: isCampaign)
    }

    private func sendNudgeTags(campaignId: String?, isCampaign: Bool, extraTags: [String: String]? = nil) {
        if isCampaign {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .campaignView,
                                                   actionName: .nudgeViewed,
                                                   categoryName: .nudge,
                                                   eventLabel: .nudgeCampaignOfferViewed,
                                                   pageName: currentPage(),
                                                   campaignId: campaignId,
                                                   extraTags: extraTags)
        } else {
            VFGAnalyticsHandler.commonUITrackEvent(eventName: .messageView,
                                                   actionName: .nudgeViewed,
                                                   categoryName: .nudge,
                                                   eventLabel: .nudgeMessageViewed,
                                                   pageName: currentPage(),
                                                   extraTags: extraTags)
        }
    }

    internal func showNudge() {
        nudgeView.willDisappear = false
        refreshTopBar()
        shouldNudgeView = true
        nudgeView.isHidden = false
        nudgeViewHeightConstraint.constant = nudgeView.currentHeight
        currentTopBarScrollState.topBarInitialY = nudgeView.currentHeight
        currentTopBarScrollState.topBar = topBar
        configureVerticalSpacingTopBar(willShowNudge: true)

        UIView.animate(withDuration: VFGRootViewConst.animationDurationTime, animations: {[weak self] in
            self?.floatingBubble?.updateBubblePosition(isNudgeVisible: true)
            self?.showNudgeClosure?()
            self?.view.layoutIfNeeded()
        })
    }

    @objc public func hideNudgeView() {
        nudgeView.willDisappear = true
        if nudgeView.isHidden {
            return
        }
        refreshTopBar()
        configureNudgeHeightConstraint()
        currentTopBarScrollState.topBarInitialY = VFGCommonUISizes.statusBarHeight
        currentTopBarScrollState.topBar = topBar
        configureVerticalSpacingTopBar(willShowNudge: false)

        UIView.animate(withDuration: VFGRootViewConst.animationDurationTime, animations: {[weak self] in
            self?.floatingBubble?.updateBubblePosition(isNudgeVisible: false)
            self?.hideNudgeClosure?()
            self?.view.layoutIfNeeded()
        }, completion: { (_) in
            self.nudgeView.isHidden = true
        })
    }

    internal func hideNudgeViewTemp() {
        let showNudgeTmp = shouldNudgeView
        hideNudgeView()
        shouldNudgeView = showNudgeTmp
    }

    internal func shouldNudgePersist(_ showNudge: Bool) {
        if shouldNudgeView {
            if showNudge {
                self.showNudge()
            } else {
                self.hideNudgeView()
            }
        }
    }

}
