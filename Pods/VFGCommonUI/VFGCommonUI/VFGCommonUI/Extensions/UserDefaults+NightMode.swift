//
//  UserDefaults+NightMode.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 29/03/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UserDefaults {

    private struct Keys {
        static let nightMode: String = "SplashNightMode"
    }

    public var nightMode: Bool {
        get {
            return bool(forKey: Keys.nightMode)
        }
        set {
            set(newValue, forKey: Keys.nightMode)
        }
    }

}
