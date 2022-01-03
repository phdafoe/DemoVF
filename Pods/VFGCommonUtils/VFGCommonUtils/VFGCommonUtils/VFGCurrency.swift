//
//  VFGCurrency.swift
//  VFGCommonUtils
//
//  Created by Sandra Morcos on 11/12/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

public class VFGCurrency {

    public class func symbol(with code: String?, fallback: String = "€") -> String {
        guard let currencyCode = code else { return fallback }
        for localedId in Locale.availableIdentifiers {
            let locale: Locale = Locale(identifier: localedId)
            if locale.currencyCode == currencyCode {
                return locale.currencySymbol ?? fallback
            }
        }
        return fallback
    }

}
