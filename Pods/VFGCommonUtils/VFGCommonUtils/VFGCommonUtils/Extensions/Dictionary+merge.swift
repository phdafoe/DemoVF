//
//  Dictionary+merge.swift
//  VFGCommonUtils
//
//  Created by Mohamed Mahmoud Zaki on 2/7/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
extension Dictionary {
    public mutating func merge(dic: Dictionary) {
        merge(dic) { (_, second) in second }
    }
}
