//
//  VFGTealiumHelper.swift
//  VFGAnalytics
//
//  Created by Ehab Alsharkawy on 8/2/17.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

@objc open class VFGTealiumHelper: NSObject {

    static let tealiumDataSourceKeyAutotracked: String = "autotracked"
    static let tealiumDataSourceValueFalse: String = "false"
    static let tealiumEnabledPlistKey: String = "TealiumEnabled"
    /**
     * Tealium command id a string value of voice of vodafone new messages
     */
    static let vovMessagesCommandIdString: String  = "vov-new-messages"
    static let vovMessagesCommandDescrptionString: String  = "vov-new-messages remote command"

    /**
     * Tealium command id a string value of voice of vodafone offers
     */
    static let vovOffersCommandIdString: String  = "vov-get-offers"
    static let vovOffersCommandDescrptionString: String  = "vov-get-offers remote command"

    static let adobeVisitorId: String = "visitor_vfmid_amcvid"
    @objc public static let shared = VFGTealiumHelper()
    @objc public  var tealiumInstanceID: String = ""
    private var tealiumEnabledInternal: Bool?

    private var trackEventCache : [(title: String, dataSources: [String: Any])] = [(String, [String: Any])]()
    private var trackViewCache : [(title: String, dataSources: [String: Any])] = [(String, [String: Any])]()

    let adbLockQueue = DispatchQueue(label: "VFGTealiumHelper", attributes: .concurrent)
    internal var waitingForADBMobile: Bool = true

    private var adobeTargetRequestQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Call Adobe Target API"
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private func clearCache() {
        self.trackViewCache.forEach { (cacheEntry : (title: String, dataSources: [String: Any])) in
            self.trackView(cacheEntry.title, dataSources: cacheEntry.dataSources)
        }
        self.trackViewCache.removeAll()

        self.trackEventCache.forEach { (cacheEntry : (title: String, dataSources: [String: Any])) in
            self.trackEvent(cacheEntry.title, dataSources: cacheEntry.dataSources)
        }
        self.trackEventCache.removeAll()
    }

    @objc public var tealiumEnabled: Bool {
        get {
            if tealiumEnabledInternal == nil {
                if let plistDictionary: [String: Any] = infoPlistDictionary() {
                    if let tealiumEnabled: Bool = plistDictionary[VFGTealiumHelper.tealiumEnabledPlistKey] as? Bool {
                        tealiumEnabledInternal = tealiumEnabled
                    }
                }
                tealiumEnabledInternal = false
            }
            return tealiumEnabledInternal!
        }
        set (newValue) {
            tealiumEnabledInternal = newValue
        }
    }

    @objc public var onNewMessagesCommand: ((NSObject?) -> Void)?

    @objc public var onGetOffersCommand: ((NSObject?) -> Void)?

    typealias ConfigurationWithAccountType = @convention(c)(AnyClass?, Selector, String, String, String) -> NSObject?

    @objc public class func startTracking(account: String, profile: String, environment: String, instanceID: String) {

        VFGTealiumHelper.shared.tealiumInstanceID = instanceID
        let selector: Selector = NSSelectorFromString("configurationWithAccount:profile:environment:")

        guard let tealConfigurationClass: AnyClass = NSClassFromString("TEALConfiguration"),
            let method: Method = class_getClassMethod(tealConfigurationClass, selector) else {
                return
        }

        let methodIMP: IMP! = method_getImplementation(method)
        if let config: NSObject = unsafeBitCast(methodIMP,
                                                to: ConfigurationWithAccountType.self)(tealConfigurationClass,
                                                                                       selector,
                                                                                       account,
                                                                                       profile,
                                                                                       environment) {
            config.setValue(3, forKey: "logLevel")
            let selector2: Selector = NSSelectorFromString("newInstanceForKey:configuration:")
            guard let tealiumClass: AnyClass = NSClassFromString("Tealium"),
                let method: Method = class_getClassMethod(tealiumClass, selector2) else {
                    return
            }
            let methodIMP2: IMP! = method_getImplementation(method)

            typealias NewInstanceFunctionType = @convention(c)(AnyClass?, Selector, String, NSObject?) -> NSObject?
            if let tealiumInstance: NSObject = unsafeBitCast(methodIMP2,
                                                             to: NewInstanceFunctionType.self)(tealiumClass,
                                                                                               selector,
                                                                                               instanceID,
                                                                                               config) {
                tealiumInstance.setValue(VFGTealiumHelper.shared, forKey: "delegate")
                VFGTealiumHelper.shared.addAdobeCloudQueue()
                VFGTealiumHelper.incrementLifetimeValue(tealiumInstance, key: "Launches")
                VFGTealiumHelper.shared.addRemoteCommandForVovMessages()
                VFGTealiumHelper.addComponentVersions()
                let dataSources: [String: Any] = [tealiumDataSourceKeyAutotracked: tealiumDataSourceValueFalse]
                VFGTealiumHelper.shared.trackEvent("Launch", dataSources: dataSources)
            }
        }
    }

    private func addAdobeCloudQueue() {
        let adobeTargetOperation = BlockOperation(block: {
            VFGAdobeMobileSDKHandler.setup(success: { (cloudIdString) in
                self.adbLockQueue.sync {
                    VFGTealiumHelper.shared.addVolatileDataSources([VFGTealiumHelper.adobeVisitorId: cloudIdString])
                    self.waitingForADBMobile = false
                }
                self.clearCache()
            }, failure: {
                self.adbLockQueue.sync {
                    self.waitingForADBMobile = false
                }
                self.clearCache()
            })
        })

        VFGTealiumHelper.shared.adobeTargetRequestQueue.addOperation(adobeTargetOperation)
    }

    func tealiumInstanceFor(_ tealiumID: String) -> NSObject? {
        let selector: Selector = NSSelectorFromString("instanceForKey:")
        if let tealiumClass: AnyClass = NSClassFromString("Tealium"),
            let method: Method = class_getClassMethod(tealiumClass, selector) {

            let methodIMP: IMP! = method_getImplementation(method)
            typealias InstanceForKeyFunctionType = @convention(c)(AnyClass?, Selector, String) -> NSObject

            return unsafeBitCast(methodIMP, to: InstanceForKeyFunctionType.self)(tealiumClass, selector, tealiumID)
        } else {
            return nil
        }
    }

    private func infoPlistDictionary() -> [String: Any]? {
        guard let fileUrl: URL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data: Data = try? Data(contentsOf: fileUrl) else {
                return nil
        }

        guard let plistDict = try? PropertyListSerialization.propertyList(from: data,
                                                                          options: [],
                                                                          format: nil) as? [String: Any] else {
                                                                            return nil
        }
        return plistDict
    }

    func isTealiumEnabled() -> Bool {
        if let plistDictionary: [String: Any] = infoPlistDictionary() {
            if let tealiumEnabled: Bool = plistDictionary[VFGTealiumHelper.tealiumEnabledPlistKey] as? Bool {
                return tealiumEnabled
            }
        }
        return false
    }

    /**
     *  Copy of all non persistent, UI object and dispatch specific data sources
     *  captured by a Tealium library instance at time of call.
     *
     *  @return Dictionary of Tealium Data Source keys and values at time of call.
     */
    @objc public func getVolatileDataSources() -> Any? {
        if let tealiumInstance: NSObject = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID) {
            let selector: Selector = NSSelectorFromString("volatileDataSourcesCopy")

            if let methodIMP: IMP = tealiumInstance.method(for: selector) {
                typealias VolatileDataSourcesCopyFunctionType = @convention(c)(Any?, Selector) -> Any?

                let result = unsafeBitCast(methodIMP,
                                           to: VolatileDataSourcesCopyFunctionType.self)(tealiumInstance, selector)

                if !(result is NSNull) && result != nil {
                    return result
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }

        VFGInfoLog("returns nil")
        return nil
    }

    /**
     *  Adds additional data to the temporary data sources dictionary. This command
     *  is added to the end of the current Tealium background queue for writing.
     *
     *  @param additionalDataSources New or overwrite data sources to add to the
     *  volatile data sources store.  These key values can only be superceded by the
     *  custom data sources added to track calls. If a value is an array, be sure to use
     *  an array of strings.
     *
     */
    @objc public func addVolatileDataSources(_ dataSources: [String: Any]) {
        let selector: Selector = NSSelectorFromString("addVolatileDataSources:")
        _ = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID)?.perform(selector,
                                                                                        with: dataSources)
    }

    /**
     *  Copy of all persistent, UI object and dispatch specific data sources
     *  captured by a Tealium library instance at time of call.
     *
     *  @return Dictionary of Tealium Data Source keys and values at time of call.
     */
    @objc public func getPersistentDataSources() -> [AnyHashable: Any]? {
        if let tealiumInstance: NSObject = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID) {
            let selector: Selector = NSSelectorFromString("persistentDataSourcesCopy")
            let methodIMP: IMP! = tealiumInstance.method(for: selector)

            typealias VolatileDataSourcesCopyFunctionType = @convention(c)(Any?, Selector) -> [AnyHashable: Any]
            return unsafeBitCast(methodIMP, to: VolatileDataSourcesCopyFunctionType.self)(tealiumInstance, selector)
        }

        VFGInfoLog("returns nil")
        return nil
    }

    /**
     *  Adds additional data to the persistent data sources dictionary.
     *
     *  @param additionalDataSources New or overwrite data sources to add to the
     *  persistent data sources store.
     *
     */
    @objc public func addPersistentDataSources(_ dataSources: [String: Any]) {
        let selector: Selector = NSSelectorFromString("addPersistentDataSources:")
        _ = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID)?.perform(selector,
                                                                                        with: dataSources)
    }

    // This is temporary solution. Should be removed when tealium will adjust content language
    // based on language instead of country.
    private func tealiumLocale() -> String {
        var result: String = VFGConfiguration.locale.identifier

        if result.hasPrefix("el") {
            result = "el_GR"
        }

        return result
    }

    func trackEvent(_ title: String, dataSources: [String: Any]) {
        self.adbLockQueue.sync {
            if self.waitingForADBMobile {
                self.trackEventCache.append((title, dataSources))
            } else if self.tealiumEnabled {
                VFGInfoLog("trackEvent:\(title)")
                var dataSources = dataSources

                if dataSources["event_name"] == nil {
                    dataSources["event_name"] = title
                }
                let selector: Selector = NSSelectorFromString("trackEventWithTitle:dataSources:")
                _ = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID)?.perform(selector,
                                                                                                with: title,
                                                                                                with: dataSources)
            }
        }
    }

    func trackView(_ title: String, dataSources: [String: Any]) {
        self.adbLockQueue.sync {
            if self.waitingForADBMobile {
                self.trackViewCache.append((title, dataSources))
            } else if self.tealiumEnabled {
                let selector: Selector = NSSelectorFromString("trackViewWithTitle:dataSources:")
                _ = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID)?.perform(selector,
                                                                                                with: title,
                                                                                                with: dataSources)
            }
        }
    }

    func stopTracking() {
        let selector: Selector = NSSelectorFromString("destroyInstanceForKey:")
        if let tealiumClass: AnyClass = NSClassFromString("Tealium"),
            let method: Method = class_getClassMethod(tealiumClass, selector) {

            let methodIMP: IMP! = method_getImplementation(method)

            typealias DestroyInstanceForKeyFunctionType = @convention(c)(AnyClass?, Selector, String) -> NSObject

            _ = unsafeBitCast(methodIMP,
                              to: DestroyInstanceForKeyFunctionType.self)(tealiumClass,
                                                                          selector,
                                                                          VFGTealiumHelper.shared.tealiumInstanceID)
        }
    }
}

extension VFGTealiumHelper {

    @objc public func tealium(_ tealium: NSObject!, shouldDrop dispatch: NSObject!) -> Bool {
        return false
    }

    public func tealium(_ tealium: NSObject!, shouldQueueDispatch dispatch: NSObject!) -> Bool {
        return false
    }
}

// MARK: Example Methods using other Tealium APIs
extension VFGTealiumHelper {

    private typealias PersistentDataSourcesCopyType = @convention(c)(Any?, Selector) -> [AnyHashable: Any]

    class func incrementLifetimeValue(_ tealium: NSObject, key: String, value: Int = 1) {
        var oldNumber: Int = 0
        let selector: Selector = NSSelectorFromString("persistentDataSourcesCopy")
        let methodIMP: IMP! = tealium.method(for: selector)

        let persistentData: [AnyHashable: Any] =
            unsafeBitCast(methodIMP, to: PersistentDataSourcesCopyType.self)(tealium, selector)

        if let savedNumberStr = persistentData[key] as? String,
            let savedNumber = Int(savedNumberStr) {
            oldNumber = savedNumber
        }

        oldNumber += value
        tealium.perform(NSSelectorFromString("addPersistentDataSources:"), with: [key: "\(oldNumber)"])

        VFGInfoLog("Current lifetime \(key):\(oldNumber)")
    }

    fileprivate func handleNewMessagesCommand(_ response: NSObject?) {
        VFGInfoLog("handleNewMessagesCommand call")
        VFGTealiumHelper.shared.onNewMessagesCommand?(response)
    }

    fileprivate func handleGetOffersCommand(_ response: NSObject?) {
        VFGInfoLog("handleGetOffersCommand call")
        VFGTealiumHelper.shared.onGetOffersCommand?(response)
    }

    func addRemoteCommand(_ commandId: String,
                          _ commandDescription: String,
                          _ commandHandler: @escaping (NSObject?) -> Void) {
        if let tealiumInstance: NSObject = self.tealiumInstanceFor(VFGTealiumHelper.shared.tealiumInstanceID) {
            let selector: Selector = NSSelectorFromString("addRemoteCommandID:description:targetQueue:responseBlock:")
            let methodIMP: IMP! = tealiumInstance.method(for: selector)
            typealias AddRemoteCommandType = @convention(c)(Any?,
                Selector,
                String,
                String,
                DispatchQueue,
                @escaping (NSObject?) -> Void) -> Void
            _ = unsafeBitCast(methodIMP,
                              to: AddRemoteCommandType.self)(tealiumInstance,
                                                             selector,
                                                             commandId,
                                                             commandDescription,
                                                             DispatchQueue.main, { (response: NSObject?) -> Void in
                                                                commandHandler(response)
                              })
        }
    }

    @objc public func addRemoteCommandForVovMessages() {
        self.addRemoteCommand(VFGTealiumHelper.vovMessagesCommandIdString,
                              VFGTealiumHelper.vovMessagesCommandDescrptionString,
                              handleNewMessagesCommand)
        self.addRemoteCommand(VFGTealiumHelper.vovOffersCommandIdString,
                              VFGTealiumHelper.vovOffersCommandDescrptionString,
                              handleGetOffersCommand)
    }
}
