//
//  String+Log.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 01/10/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension String {

    internal static func logFileName(with prefix: String) -> String {
        let date = DateFormatter.logFileNameDateFormatter.string(from: Date())
        return "\(prefix)-\(date).log"
    }

    internal static func fullLogFilePath() -> String {
        let appName: String = Bundle.main.appName.replacingOccurrences(of: " ", with: "")
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                        .userDomainMask, true).first ?? ""
        if !FileManager.default.fileExists(atPath: documentsPath) {
            try? FileManager.default.createDirectory(atPath: documentsPath,
                                                     withIntermediateDirectories: false,
                                                     attributes: nil)
        }
        return "\(documentsPath)/\(String.logFileName(with: appName))"
    }

}
