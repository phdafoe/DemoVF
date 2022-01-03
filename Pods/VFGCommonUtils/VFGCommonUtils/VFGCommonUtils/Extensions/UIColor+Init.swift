//
//  UIColor+Init.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 31/10/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {

    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        guard let hex = hexString.hexToInt() else {
            return nil
        }
        self.init(red: hex.red/255.0, green: hex.green/255.0, blue: hex.blue/255.0, alpha: alpha)
    }

}

fileprivate extension Int {

    var red: CGFloat {
        return CGFloat((self & 0xFF0000) >> 16)
    }

    var green: CGFloat {
        return CGFloat((self & 0xFF00) >> 8)
    }

    var blue: CGFloat {
        return CGFloat(self & 0xFF)
    }

}

fileprivate extension String {

    struct Const {
        static let prefix = "0x"
        static let hash = "#"
        static let empty = ""
    }

    func removePrefix() -> String {
        let formatted = replacingOccurrences(of: Const.prefix, with: Const.empty)
        return formatted.replacingOccurrences(of: Const.hash, with: Const.empty)
    }

    func hexToInt() -> Int? {
        guard let hex = Int(removePrefix(), radix: 16) else {
            return nil
        }
        return hex
    }

}
