//
//  VFGEnvironment.swift
//  VFGCommonUtils
//
//  Created by kasa on 18/01/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGEnvironment: NSObject {

    /**
     Dictionary of registered group components. Use component name as a key and version as value.
     (eg. "VFGCommonUtils" : "1.0.0")
     */
    @objc static public var registeredComponents = [
        VFGCommonUtilsBundle.bundleName: VFGCommonUtilsBundle.bundleVersion
    ]

    /**
     Determines whether application is running on Simulator.
     - Returns: true if running on simulator, false otherwise
     */
    @objc static public func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    /**
     Check if VFGCommonUtils is build with Debug configuration
     - Returns: true if Debug, false otherwise
     */
    class func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

}
