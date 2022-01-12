//
//  UserGuidesNavigation.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

public final class VFGUserGuidesNavigation: Equatable {
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

    public static func == (lhs: VFGUserGuidesNavigation, rhs: VFGUserGuidesNavigation) -> Bool {
        return lhs.navigationId == rhs.navigationId && lhs.navigationTitle == rhs.navigationTitle
    }
}

extension VFGUserGuidesNavigation.Kind {
    public var buttonStyle: MVA10ButtonStyle {
        switch self {
        case .app:
            return .primary
        case .userguides:
            return .secondary
        }
    }
}
