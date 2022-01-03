//
//  ComponentManifest.swift
//  VFGCommonUtils
//
//  Created by Mateusz Zakrzewski on 23.05.2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol ComponentHost: NSObjectProtocol {
    @objc func componentDidGenerateEvent(_ event: String)
}

@objc public protocol ComponentManifest: NSObjectProtocol {
    var componentName: String { get }
    var componentVersion: String { get }
    @objc static func startComponent() -> ComponentManifest
    @objc func stopComponent() -> Bool
    @objc func setContentManager(_ contentManager: VFGContentManager)
    @objc optional func componentView() -> UIView
    @objc optional func componentViewController() -> UIViewController
}
