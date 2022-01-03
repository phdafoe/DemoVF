//
//  VFGCommonUIBundle.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 17.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "use Bundle.vfgCommonUI")
@objc public class VFGCommonUIBundle: NSObject {
    private static let bundleName = "VFGCommonUI"
    private static let bundleExtension = "bundle"

    private static let bundleIdentifier = "com.vodafone.VFGCommonUI"

    @objc public static func bundle() -> Bundle? {
        return Bundle.vfgCommonUI
    }

    @objc public static func customBundle() -> Bundle? {
        guard let bundleString: URL = Bundle.vfgCommonUI.url(forResource: "Base",
                                                             withExtension: "lproj") else {
            return nil
        }
        return Bundle(url: bundleString)
    }

}
