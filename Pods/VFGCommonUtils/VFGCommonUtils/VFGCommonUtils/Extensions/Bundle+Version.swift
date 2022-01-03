//
//  Bundle+Version.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 01/10/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

private struct Keys {
    static let shortVersion = "CFBundleShortVersionString"
    static let version = "CFBundleVersion"
    static let executable = "CFBundleExecutable"
}

private struct Const {
    static let unknown = "Unknown"
}

extension Bundle {
    public var shortVersion: String {
        return self.object(forInfoDictionaryKey: Keys.shortVersion) as? String ?? Const.unknown
    }

    public var version: String {
        return self.object(forInfoDictionaryKey: Keys.version) as? String ?? Const.unknown
    }

    public var appName: String {
        return self.object(forInfoDictionaryKey: Keys.executable) as? String ?? Const.unknown
    }

}
