//
//  VFGSnackbar.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import SwiftMessages
import VFGCommonUtils

@objc open class VFGSnackbar: NSObject {
    /**
       View which will be passed to SwiftMessages.show().
       This property can be used to customize message displayed by SwiftMessages pod.
    */
    @objc public var messageView = MessageView.viewFromNib(layout: .messageView)
    @objc public var shouldSendTags: Bool = true

    @objc open func show(message: String,
                         duration: TimeInterval,
                         image: UIImage?,
                         shouldSendTags: Bool = true) {

        let icon = UIImage(fromCommonUINamed: "tick")

        messageView.configureTheme(backgroundColor: .black, foregroundColor: .white, iconImage:
            image ?? icon, iconText: nil)

        messageView.configureContent(title: "", body: message)

        messageView.button?.removeFromSuperview()

        messageView.bodyLabel?.font = UIFont.VFGXL() ?? UIFont.systemFont(ofSize: 20)

        var config = SwiftMessages.Config()

        // StatusBar style matches the rootViewController.
        config.preferredStatusBarStyle = VFGRootViewController.shared.preferredStatusBarStyle

        // Slide up from the bottom.
        config.presentationStyle = .bottom

        // Display in a window at the specified window level: UIWindowLevelStatusBar
        // displays over the status bar while UIWindowLevelNormal displays under.
        config.presentationContext = .window(windowLevel: UIWindow.Level.alert)

        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: duration)

        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append { event in
            if case .didHide = event { VFGDebugLog("didHide") }
        }

        SwiftMessages.show(config: config, view: messageView)
        if shouldSendTags {
            sendSnackbarTags()
        }
    }

    @objc open func show(message: String,
                         duration: TimeInterval,
                         image: UIImage?,
                         shouldSendTags: Bool = true,
                         extraTags: [String: String] = [:]) {
        self.show(message: message,
                  duration: duration,
                  image: image,
                  shouldSendTags: false)
        if shouldSendTags {
            sendSnackbarTags(extraTags: extraTags)
        }
    }

    private func sendSnackbarTags(extraTags: [String: String]? = nil) {
        VFGAnalyticsHandler.commonUITrackEvent(
            eventName: .messageView,
            actionName: .toastViewed,
            categoryName: .toast,
            eventLabel: .toastMessageViewed,
            pageName: VFGRootViewController.shared.currentPage(),
            extraTags: extraTags)
    }
}
