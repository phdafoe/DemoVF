//
//  Bundle+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 10/04/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension Bundle {
    @objc public class var vfgCommonUI: Bundle {
        return Bundle(for: VFGRootViewController.self)
    }
}
