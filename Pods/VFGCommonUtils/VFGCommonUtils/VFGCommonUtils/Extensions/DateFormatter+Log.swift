//
//  DateFormatter+Log.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 01/10/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension DateFormatter {

    internal static var logFileNameDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy.MM.dd-HH.mm.ss"
        return formatter
    }()

    internal static var logEntryDateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter
    }()

}
