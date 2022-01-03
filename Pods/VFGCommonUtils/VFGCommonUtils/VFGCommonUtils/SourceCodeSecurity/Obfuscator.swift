//
//  Obfuscator.swift
//  VFGCommonUtils
//
//  Created by Mohamed Abd ElNasser on 10/9/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

public class Obfuscator {
    // The salt used to obfuscate and reveal the string.
    private var salt: String
    public init() {
        self.salt = "kF]SEI0#T/l{:y4"
    }

    public func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        var encrypted = [UInt8]()

        for textItem in text.enumerated() {
            encrypted.append(textItem.element ^ cipher[textItem.offset % length])
        }
        return encrypted
    }

    public func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        var decrypted = [UInt8]()

        for keyItem in key.enumerated() {
            decrypted.append(keyItem.element ^ cipher[keyItem.offset % length])
        }
        guard let result = String(bytes: decrypted, encoding: .utf8) else {
            return ""
        }
        return result
    }

}
