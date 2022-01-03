//
//  JSONCodable.swift
//  VFGCommonUtils
//
//  Created by Mohamed ELMeseery on 11/27/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

public typealias JSONCodable = JSONEncodable & JSONDecodable

// MARK: JSONDecodable
public protocol JSONDecodable {}
public extension JSONDecodable where Self: Decodable {
    static var decoder: JSONDecoder { return JSONDecoder() }
    init?(JSONString: String?) {
        guard let json = JSONString,
            let jsonData = json.data(using: .utf8),
            let anInstance = try? Self.decoder.decode(Self.self, from: jsonData) else {return nil}
        self = anInstance
    }

    init?(jsonData: Data?) {
        guard let data = jsonData,
            let anInstance = try? Self.decoder.decode(Self.self, from: data)
            else { return nil }
        self = anInstance
    }

    init?(JSON: [String: Any]?) {
        guard let json = JSON,
            json.count > 0,
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
            let anInstance = Self(jsonData: jsonData) else {
                return nil
        }
        self = anInstance
    }
}
// MARK: JSONEncodable
public protocol JSONEncodable {}
public extension JSONEncodable where Self: Encodable {
    static var encoder: JSONEncoder { return JSONEncoder() }
    func jsonData() -> Data? {
        return try? Self.encoder.encode(self)
    }

    func toJSONString() -> String? {
        guard let jsonData = try? Self.encoder.encode(self),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else {
                return nil
        }
        return jsonString
    }

    func toJSON() -> [String: Any]? {
        guard let jsonData = try? Self.encoder.encode(self),
            let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let json = jsonObj as? [String: Any]
            else { return nil }
        return json
    }
}
