//
//  Date+Calculation.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 31/10/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension Date {
    public func secondsBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }
}
