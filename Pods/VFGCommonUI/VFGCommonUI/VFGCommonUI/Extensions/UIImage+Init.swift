//
//  UIImage+Init.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 16/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension UIImage {
    convenience init?(named name: String, in bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}
