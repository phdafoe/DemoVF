//
//  FailableDecodable.swift
//  VFGCommonUtils
//
//  Created by Mohamed ELMeseery on 11/27/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

public struct FailableDecodable<Base: Decodable>: Decodable {
    public let base: Base?
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.base = try container.decode(Base.self)
        } catch {
            self.base = nil
        }
    }
}
