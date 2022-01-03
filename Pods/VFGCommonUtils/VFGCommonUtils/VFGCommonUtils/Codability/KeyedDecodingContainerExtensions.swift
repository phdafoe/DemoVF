//
//  KeyedDecodingContainerExtensions.swift
//  VFGCommonUtils
//
//  Created by Mohamed ELMeseery on 11/28/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
// MARK: Encode `Any` type.
extension KeyedEncodingContainer {
    public mutating func encodeAny(_ value: Any?, forKey key: K) throws {
        switch value {
        case is Void:
            try? self.encodeNil(forKey: key)
        case let bool as Bool:
            try? self.encode(bool, forKey: key)
        case let int as Int:
            try? self.encode(int, forKey: key)
        case let uint as UInt:
            try? self.encode(uint, forKey: key)
        case let float as Float:
            try? self.encode(float, forKey: key)
        case let double as Double:
            try? self.encode(double, forKey: key)
        case let string as String:
            try? self.encode(string, forKey: key)
        case let date as Date:
            try? self.encode(date, forKey: key)
        case let url as URL:
            try? self.encode(url, forKey: key)
        default:
            let context = EncodingError
                .Context(codingPath: self.codingPath, debugDescription: "Any value cannot be encoded")
            throw EncodingError.invalidValue(value as Any, context)
        }
    }
}

// MARK: Decode `Any` type.
extension KeyedDecodingContainer {
    public func decodeAny(_ key: K) throws -> Any? {
        if let bool = try? self.decode(Bool.self, forKey: key) {
            return bool
        } else if let int = try? self.decode(Int.self, forKey: key) {
            return int
        } else if let uint = try? self.decode(UInt.self, forKey: key) {
            return uint
        } else if let float = try? self.decode(Float.self, forKey: key) {
            return float
        } else if let double = try? self.decode(Double.self, forKey: key) {
            return double
        } else if let string = try? self.decode(String.self, forKey: key) {
            return string
        } else if let date = try? self.decode(Date.self, forKey: key) {
            return date
        } else if let url = try? self.decode(URL.self, forKey: key) {
            return url
        } else if try self.decodeNil(forKey: key) {
            return nil
        } else {
            throw DecodingError
                .dataCorruptedError(forKey: key, in: self, debugDescription: "Any value cannot be decoded")
        }
    }

    public func decodeAnyIfPresent(forKey key: K) throws -> Any? {
        if !contains(key) {
            return nil
        }
        return try decodeAny(key)
    }
}

// MARK: Decodable object to Dictionary.
extension KeyedDecodingContainer {
    public func toDictionary() throws -> [String: Any] {
        var dictionary: [String: Any] = [: ]
        for key in allKeys {
            dictionary[key.stringValue] = try decodeAny(key)
        }
        return dictionary
    }
}

// MARK: Access decodable object directly [key].
extension KeyedDecodingContainer {
    public subscript<T: Decodable>(key: KeyedDecodingContainer.Key) -> T? {
        return try? decode(T.self, forKey: key)
    }
}

// MARK: Decoding with type inference.
extension KeyedDecodingContainer {
    public func decodeIfPresentSafely<T: Decodable>(key: K) -> T? {
        return (try? decodeIfPresent(T.self, forKey: key)) ?? nil
    }

    public func decodeIfPresent<T: Decodable>(key: K) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    public func decode<T: Decodable>(key: K) throws -> T? {
        return try? decode(T.self, forKey: key)
    }
}
