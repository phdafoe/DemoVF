//
//  String+Localization.swift
//  VFGNotifications
//
//  Created by ahmed elshobary on 3/29/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

/**
 Internal catergory which returns localized strings for CommonUI classes
 */
internal extension String {

    var localized: String {
        return localizedWithBundle(Bundle.vfgCommonUI)
    }

}
