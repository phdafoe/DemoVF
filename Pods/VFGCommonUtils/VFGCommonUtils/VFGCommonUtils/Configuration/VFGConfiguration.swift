//
//  VFGConfiguration.swift
//  VFGCommonUtils
//
//  Created by kasa on 02/11/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Configuration of the CommonUtils component stored in encrypted CoreData
 */
@objc public class VFGConfiguration: NSObject {
    static fileprivate let defaultLocale: String = "en_GB"
    static fileprivate let currentLocaleKey = "CurrentLocale"
    @objc static public var locale: Locale! {
        get {
            let userDefaults = UserDefaults.standard
            guard let localeString: String = userDefaults.string(forKey: VFGConfiguration.currentLocaleKey) else {
                return Locale.current
            }
            return Locale(identifier: localeString)
        }
        set(newLocale) {
            if newLocale == nil {
                UserDefaults.standard.removeObject(forKey: VFGConfiguration.currentLocaleKey)
            } else {
                UserDefaults.standard.set(newLocale.identifier, forKey: VFGConfiguration.currentLocaleKey)
            }
            UserDefaults.standard.synchronize()
        }
    }

}
