//
//  VFGPrivacyPolicyCard.swift
//  PrivacyOptions
//
//  Created by Ahmed Askar on 8/21/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import Foundation
import UIKit

public class VFGPrivacyPolicyCard {

    public var cardTitle: String
    public var cardContents: [VFGPrivacyOptionsContentCard]

    public init(cardTitle: String, cardContents: [VFGPrivacyOptionsContentCard]) {
        self.cardTitle = cardTitle
        self.cardContents = cardContents
    }
}

public class VFGPrivacyOptionsContentCard {

    public var contentType: ParagraphContentType

    public init(contentType: ParagraphContentType) {
        self.contentType = contentType
    }
}

public enum ParagraphContentType {
    case normal
    case bullets
}

public class NormalParagraph: VFGPrivacyOptionsContentCard {
    public var paragraph: String

    required public init(paragraph: String) {
        self.paragraph = paragraph
        super.init(contentType: .normal)
    }
}

public class ParagraphWithBullets: VFGPrivacyOptionsContentCard {

    public var paragraph: String
    public var bullets: [String]

    required public init(paragraph: String, bullets: [String]) {
        self.paragraph = paragraph
        self.bullets = bullets
        super.init(contentType: .bullets)
    }
}

public class NormalParagraphWithAction: VFGPrivacyOptionsContentCard {
    public var paragraph: String
    public var actionTitle: String
    public var action : () -> Void
    required public init(paragraph: String, actionTitle: String, action : @escaping () -> Void) {
        self.paragraph = paragraph
        self.actionTitle = actionTitle
        self.action = action
        super.init(contentType: .normal)
    }
}

public class VFGPrivacyPolicySection {

    public var sectionTitle: String
    public var cards: [VFGPrivacyPolicyCard]

    public init(sectionTitle: String, cards: [VFGPrivacyPolicyCard]) {
        self.sectionTitle = sectionTitle
        self.cards = cards
    }
}

public class PermissionItem {
    public var icon: PermissionItemIcon
    public var title: String
    public var description: String
    required public init(icon: PermissionItemIcon, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

public enum PermissionItemIcon {
    case phone
    case sms
    case location
    case other(UIImage)
}
