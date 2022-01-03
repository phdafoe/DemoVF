//
//  String+Localization.swift
//  VFGCommonUtils
//
//  Created by Ahmed Naguib on 9/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

/**
 Extension which provides localized strings
 */
extension String {

    /**
     This method returns localized strings from main or component bundle.
     - parameter bundle: component bundle which should contain base translation.
     - returns: translation from main application bundle or base version from component bundle.
     */
    public func localizedWithBundle(_ bundle: Bundle) -> String {
        let missingKeyValue: String = "//VFGMissingKey!!!"
        let tableName: String? = bundle.bundleIdentifier?.components(separatedBy: ".").last

        var newBundle = Bundle.main
        if let appleLanguages = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String],
            let lang = appleLanguages.first?.split(separator: "-").first,
            let path = Bundle.main.path(forResource: String(lang), ofType: "lproj") {
            newBundle = Bundle(path: path) ?? Bundle.main
        }

        let result: String = NSLocalizedString(self, tableName: tableName,
                                               bundle: newBundle,
                                               value: missingKeyValue,
                                               comment: "")

        if result.lowercased() != missingKeyValue.lowercased() {
            return result
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
