//
//  VFUserGuidesProtocol.swift
//  EverisVodafoneFoundation
//
//  Created by Everis on 16/9/21.
//

import Foundation

public protocol VFUserGuidesProtocol: class {
    func viewIsReady(userGuides: UserGuides)
    func viewWillClose(userGuides: UserGuides, page: UserGuidesPage)
    func sectionActionRequested(userGuides: UserGuides, page: UserGuidesPage)
    func nextActionRequested(userGuides: UserGuides, page: UserGuidesPage)
}
