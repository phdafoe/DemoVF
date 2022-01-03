//
//  VFGTealiumHelper+Components.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 20/03/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFGTealiumHelper {

    private static let components: [String: String] = [
        "billing_version": "VFGBilling",
        "commonui_version": "VFGCommonUI",
        "commonutils_version": "VFGCommonUtils",
        "dataaccess_version": "VFGDataAccess",
        "foundation_version": "VFGFoundation",
        "needhelp_version": "VFGNeedHelp",
        "netperform_version": "VFGNetPerform",
        "notifications_version": "VFGNotifications",
        "securestorage_version": "VFGSecureStorage",
        "splash_version": "VFGSplash",
        "termsconditions_version": "VFGTermsConditions",
        "vov_version": "VFGVoV"
    ]

    private static var configuredTealiumInstances: [String] = [String]()

    /**
     Add versions of Vodafone components (linked to application) to Tealium VolatileDataSources
     - Parameter instanceId: Tealium instance identifier
     - Note: Call this method only once. For example after tealium instance has been initialized.
             Subsequent calls will be ignored.
     */
    @objc public class func addComponentVersions(with instanceId: String = VFGTealiumHelper.shared.tealiumInstanceID) {
        if configuredTealiumInstances.contains(instanceId) {
            VFGDebugLog("Component versions already added to tealium:\(instanceId)")
            return
        }

        var componentsVersions: [String] = [String]()
        for framework in Bundle.allFrameworks {
            guard let component = components.first(where: {
                return framework.bundleIdentifier?.contains($0.value) ?? false
            }) else {
                continue
            }
            componentsVersions.append("\(component.key)_\(framework.shortVersion)")
        }

        if componentsVersions.count == 0 {
            VFGDebugLog("No VFG components found")
            return
        }

        guard let tealium = VFGTealiumHelper.shared.tealiumInstanceFor(instanceId) else {
            VFGErrorLog("Failed to access tealiumInstance:\(instanceId)")
            return
        }
        let selector: Selector = NSSelectorFromString("addVolatileDataSources:")
        tealium.perform(selector, with: ["app_vfg_components": componentsVersions])
        configuredTealiumInstances.append(instanceId)
    }
}
