//
//  VFGRoaming.swift
//  VFGCommonUtils
//
//  Created by kasa on 13/01/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import CoreTelephony

@objc public class VFGRoaming: NSObject {

    static private let operatorPListSymLinkPath: String = "/var/mobile/Library/Preferences/com.apple.operator.plist"
    static private let carrierPListSymLinkPath: String = "/var/mobile/Library/Preferences/com.apple.carrier.plist"
    static private let deviceCarrierPrefix: String = "device+carrier+"
    static private let unknownBundle = "Unknown.bundle"
    static private let carrierPlist = "carrier.plist"
    static let minimalNumberOfExpectedPathComponents: Int = 7
    static let mobileCountryCodeLength = 3

    static private func isMobileCountryCodeBermuda(_ mcc: String) -> Bool {
        return mcc == "310" || mcc == "338" || mcc == "350"
    }

    static private func isMobileCountryCodeIndia(_ mcc: String) -> Bool {
        return mcc == "404" || mcc == "405"
    }

    static private func isMobileCountryCodeJapan(_ mcc: String) -> Bool {
        return mcc == "440" || mcc == "441"
    }

    static private func isMobileCountryCodeKosovo(_ mcc: String) -> Bool {
        return mcc == "212" || mcc == "293"
    }

    static private func isMobileCountryCodeTurksAndCaicosIslands(_ mcc: String) -> Bool {
        return mcc == "338" || mcc == "376"
    }

    static private func isMobileCountryCodeUnitedKingdom(_ mcc: String) -> Bool {
        return mcc == "234" || mcc == "235"
    }

    static private func isMobileCountryCodeUnitedStates(_ mcc: String) -> Bool {
        return mcc == "310" || mcc == "311" || mcc == "312" || mcc == "313" || mcc == "316"

    }

    static private func mobileCountryCodesAreEqual(_ codeOne: String, _ codeTwo: String) -> Bool {

        if codeOne == codeTwo {
            return true
        }

        //Special cases based on https://en.wikipedia.org/wiki/Mobile_country_code
        if isMobileCountryCodeBermuda(codeOne) && isMobileCountryCodeBermuda(codeTwo) {
            return true
        }

        if isMobileCountryCodeIndia(codeOne) && isMobileCountryCodeIndia(codeTwo) {
            return true
        }

        if isMobileCountryCodeJapan(codeOne) && isMobileCountryCodeJapan(codeTwo) {
            return true
        }

        if isMobileCountryCodeKosovo(codeOne) && isMobileCountryCodeKosovo(codeTwo) {
            return true
        }

        if isMobileCountryCodeTurksAndCaicosIslands(codeOne) && isMobileCountryCodeTurksAndCaicosIslands(codeTwo) {
            return true
        }

        if isMobileCountryCodeUnitedKingdom(codeOne) && isMobileCountryCodeUnitedKingdom(codeTwo) {
            return true
        }

        if isMobileCountryCodeUnitedStates(codeOne) && isMobileCountryCodeUnitedStates(codeTwo) {
            return true
        }

        return false
    }

    /**
     Determines whether device is using international roaming.
     This is NOT using official Apple API, use with caution.
     Local roaming is filtered out because the current approach could yield false positives
     
     @return NSNumber with possible values true, false or nil for undefined (missing simcard)
     */
    @objc static public func isInternationalRoamingActive() -> NSNumber? {
        if VFGEnvironment.isSimulator() { return nil }

        guard let simCardCountryCode: String = simCountryCode(),
            let operatorPath = destinationLink(at: operatorPListSymLinkPath) else {
            return nil
        }
        let operatorPathComponents: [String] = operatorPath.components(separatedBy: "/")
        if isValidComponents(operatorPathComponents) == false {
            return nil
        }

        var operatorCountryCode: String?
        let lastPathIndex: Int = operatorPathComponents.count - 1
        let lastComponent = operatorPathComponents[lastPathIndex]
        if lastComponent.contains(unknownBundle) {
            return roamingForUnknownBundle()
        } else if lastComponent == carrierPlist {
            operatorCountryCode = carrierCountryCode(operatorPathComponents)
        } else if lastComponent.hasPrefix(deviceCarrierPrefix) {
            operatorCountryCode = deviceCarrierCode(operatorPathComponents)
        }

        guard let countryCode: String = operatorCountryCode else {
            return nil
        }
        return NSNumber(value: !self.mobileCountryCodesAreEqual(simCardCountryCode, countryCode))
    }

    private class func destinationLink(at path: String) -> String? {
        do {
            return try FileManager.default.destinationOfSymbolicLink(atPath: path)
        } catch {
            return nil
        }
    }

    private class func deviceCarrierCode(_ components: [String]) -> String? {
        guard let networkCode = networkCode(components) else {
            return nil
        }

        let startIndex = networkCode.startIndex
        let prefix = networkCode.index(startIndex, offsetBy: mobileCountryCodeLength)
        return String(networkCode[..<prefix])
    }

    private class func carrierCountryCode(_ components: [String]) -> String {
        let startIndex = deviceCarrierPrefix.startIndex
        let lastButOnePathIndex = components.count - 2
        let prefix = components[lastButOnePathIndex].index(startIndex, offsetBy: mobileCountryCodeLength)
        return String(components[lastButOnePathIndex][..<prefix])
    }

    private class func roamingForUnknownBundle() -> NSNumber? {
        guard let carrierPListPath = destinationLink(at: carrierPListSymLinkPath),
            let operatorPListPath = destinationLink(at: operatorPListSymLinkPath) else {
                return nil
        }
        return NSNumber(value: !(carrierPListPath == operatorPListPath))
    }

    private class func networkCode(_ components: [String]) -> String? {
        let index: String.Index = deviceCarrierPrefix.index(deviceCarrierPrefix.startIndex,
                                                            offsetBy: deviceCarrierPrefix.count)
        let lastPathIndex = components.count - 1
        guard let networkCode = Int(components[lastPathIndex][index...]) else {
            return nil
        }
        return String(networkCode)
    }

    private class func simCountryCode() -> String? {
        let providerNetworkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        let provider: CTCarrier? = providerNetworkInfo.subscriberCellularProvider
        guard let simCardCountryCode: String = provider?.mobileCountryCode else {
            return nil
        }
        return simCardCountryCode
    }

    private class func isValidComponents(_ components: [String]) -> Bool {
        if components.count < minimalNumberOfExpectedPathComponents {
            VFGInfoLog("Not enough entries in:\(components)")
            return false
        }
        return true
    }
}
