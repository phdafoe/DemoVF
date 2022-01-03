//
//  UserGuidesPage.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

public final class UserGuidesPage: Equatable {
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
    let navigation: UserGuidesNavigation

    public init(pageId: String, title: String, subtitle: String, imageURL: URL? = nil, details: String? = nil, navigation: UserGuidesNavigation) {
        self.pageId = pageId
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.details = details
        self.navigation = navigation
    }

//    required convenience public init?(json: JSON) {
//        guard let pageId: String = "page_id" <~~ json else { return nil }
//        guard let title: String = DecodingKeys.title.rawValue <~~ json else { return nil }
//        guard let subtitle: String = DecodingKeys.subtitle.rawValue <~~ json else { return nil }
//        guard let navJSON: JSON = DecodingKeys.navigation.rawValue <~~ json else { return nil }
//        guard let nav = UserGuidesNavigation.init(json: navJSON) else { return nil }
//        let desc: String? = DecodingKeys.description.rawValue <~~ json
//        let imageURL: String? = DecodingKeys.image.rawValue <~~ json
//        var url: URL?
//        if let path = imageURL {
//            url = URL(string: path)
//        }
//        self.init(pageId: pageId, title: title, subtitle: subtitle, imageURL: url, details: desc, navigation: nav)
//    }
//
//    public func toJSON() -> JSON? {
//        return jsonify([
//            "page_id" ~~> pageId,
//            DecodingKeys.title.rawValue ~~> title,
//            DecodingKeys.subtitle.rawValue ~~> subtitle,
//            DecodingKeys.image.rawValue ~~> imageURL?.path,
//            DecodingKeys.description.rawValue ~~> details,
//            DecodingKeys.navigation.rawValue ~~> navigation.toJSON()
//        ])
//    }

    public static func == (lhs: UserGuidesPage, rhs: UserGuidesPage) -> Bool {
        return lhs.pageId == rhs.pageId && lhs.title == rhs.title
    }
}
