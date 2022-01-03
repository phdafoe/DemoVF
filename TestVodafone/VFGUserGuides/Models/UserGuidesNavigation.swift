//
//  UserGuidesNavigation.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

public final class UserGuidesNavigation: Equatable {
    public enum Kind: String {
        case userguides
        case app
    }

    enum CodingKeys: String, CodingKey {
        case type
        case title
    }

    let type: Kind
    let navigationTitle: String
    let navigationId: String

    public  init(title: String, identifier: String, type: Kind) {
        self.navigationTitle = title
        self.navigationId = identifier
        self.type = type
    }

    public static func == (lhs: UserGuidesNavigation, rhs: UserGuidesNavigation) -> Bool {
        return lhs.navigationId == rhs.navigationId && lhs.navigationTitle == rhs.navigationTitle
    }
//    required convenience public init?(json: JSON) {
//        guard let title: String = DecodingKeys.title.rawValue <~~ json else { return nil }
//        guard let identifier: String = "navigation_id" <~~ json else { return nil }
//        guard let typeStr: String = DecodingKeys.type.rawValue <~~ json else { return nil }
//        guard let type = Kind(rawValue: typeStr.lowercased()) else { return nil }
//        self.init(title: title, identifier: identifier, type: type)
//    }
//
//    public func toJSON() -> JSON? {
//        return jsonify([
//            DecodingKeys.type.rawValue ~~> type.rawValue,
//            DecodingKeys.title.rawValue ~~> navigationTitle,
//            "navigation_id" ~~> navigationId
//        ])
//    }
}

extension UserGuidesNavigation.Kind {
    public var buttonStyle: MVA10ButtonStyle {
        switch self {
        case .app:
            return .primary
        case .userguides:
            return .secondary
        }
    }
}
