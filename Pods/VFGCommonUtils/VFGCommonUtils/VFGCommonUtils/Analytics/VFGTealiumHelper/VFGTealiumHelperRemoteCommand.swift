//
//  VFGTealiumHelperRemoteCommand.swift
//  VFGAnalytics
//
//  Created by Mateusz Zakrzewski on 10/07/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

/**
 This enumeration defines possible remote command types
 */
@objc public enum VFGTealiumHelperRemoteCommandType: Int {
    case unknown, generic, campaign
}

/**
 This class defines Tealium command object.
 */
@objc public class VFGTealiumHelperRemoteCommand: NSObject {

    private let commandTypeKey: String = "type"
    private let commandEventNameKey: String = "event_name"
    private let genericCommandString: String = "generic"
    private let compaignCommandString: String = "compaign"

    /**
     This property stores raw remote command dictionary (same as in reasponse from Tealium).
     */
    @objc public var commandDictionary: [String: Any]?

    /**
     This property stores remote command type based on the raw command dictionary.
     */
    @objc public var commandType: VFGTealiumHelperRemoteCommandType {
        if let commandTypeString: String = commandDictionary?[commandTypeKey] as? String {
            switch commandTypeString {
            case genericCommandString:
                return .generic
            case compaignCommandString:
                return .campaign
            default:
                return .unknown
            }
        }
        return .unknown
    }
    /**
     This property provides the name of the event which triggered this remote command.
     */
    @objc public var commandEventName: String? {
        if let commandEventNameKey: String = commandDictionary?[commandEventNameKey] as? String {
            return commandEventNameKey
        }
        return ""
    }

    /**
     Default constructor.
     - parameter: raw remote command dictionary (event field content).
     */

    @objc public init(withObject object: NSObject?) {
        let requestPayloadKey: String = "requestPayload"
        let eventPayloadEvent: String = "event"

        guard let eventPayloadDict: [String: Any] = object?.value(forKey: requestPayloadKey) as? [String: Any],
            let eventPayloadCmd: [String: Any] = eventPayloadDict[eventPayloadEvent] as? [String: Any] else {
            return
        }
        self.commandDictionary = eventPayloadCmd
    }
}
