//
//  NSLayoutConstraint+Init.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 22/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension NSLayoutConstraint {

    convenience init(item: Any,
                     attribute attr1: NSLayoutConstraint.Attribute,
                     toItem: Any?,
                     attribute attr2: NSLayoutConstraint.Attribute,
                     constant: CGFloat) {
        self.init(item: item,
                  attribute: attr1,
                  relatedBy: .equal,
                  toItem: toItem,
                  attribute: attr2,
                  multiplier: 1,
                  constant: constant)
    }

}
