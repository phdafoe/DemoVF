//
//  VFGAnalytics.swift
//  VFGAnalytics
//
//  Created by kasa on 08/06/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGAnalytics: NSObject {

    @objc public static var isTrackingEnabled = true

    @objc public static var trackEventClosure : ( String, [String: Any]) -> Void = { (title: String,
                                                                                      dataSources: [String: Any]) in
        guard isTrackingEnabled else {
            return
        }
        VFGTealiumHelper.shared.trackEvent(title, dataSources: dataSources)
    }

    @objc public static var trackViewClosure : ( String, [String: Any]) -> Void = { (title: String,
                                                                                     dataSources: [String: Any]) in
        guard isTrackingEnabled else {
            return
        }
        VFGTealiumHelper.shared.trackView(title, dataSources: dataSources)
    }

    @objc public static func trackEvent(_ title: String, dataSources: [String: Any]) {
        VFGInfoLog("title:\(title) data:\(dataSources)")
        VFGAnalytics.trackEventClosure(title, dataSources)
    }

    @objc public static func trackView(_ title: String, dataSources: [String: Any]) {
        VFGInfoLog("title:\(title) data:\(dataSources)")
        VFGAnalytics.trackViewClosure(title, dataSources)
    }
}
