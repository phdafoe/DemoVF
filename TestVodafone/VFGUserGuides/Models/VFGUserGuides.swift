//
//  UserGuides.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

public struct VFGUserGuides: Equatable {
    var identifier: String?
    let initialPage: String
    let pages: [String: VFGUserGuidesPage]

    enum CodingKeys: String, CodingKey {
        case identifier
        case initialPage
        case pages
    }

    public init(initialPage: String, pages: [String: VFGUserGuidesPage]) {
        self.initialPage = initialPage
        self.pages = pages
    }

    public static func == (lhs: VFGUserGuides, rhs: VFGUserGuides) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.initialPage == rhs.initialPage
    }
}
