//
//  UserGuidesPage.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

public final class VFGUserGuidesPage: Equatable {
    enum DecodingKeys: String {
        case title
        case subtitle
        case image
        case description
        case navigation
    }

    let pageId: String
    let title: String
    let subtitle: String
    let imageURL: URL?
    let details: String?
    let navigation: VFGUserGuidesNavigation

    public init(pageId: String, title: String, subtitle: String, imageURL: URL? = nil, details: String? = nil, navigation: VFGUserGuidesNavigation) {
        self.pageId = pageId
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.details = details
        self.navigation = navigation
    }


    public static func == (lhs: VFGUserGuidesPage, rhs: VFGUserGuidesPage) -> Bool {
        return lhs.pageId == rhs.pageId && lhs.title == rhs.title
    }
}
