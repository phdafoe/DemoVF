//
//  VFGUserGuidesProtocol.swift
//  EverisVodafoneFoundation
//
//  Created by Everis on 16/9/21.
//

import Foundation

public protocol VFGUserGuidesProtocol: class {
    func viewIsReady(userGuides: VFGUserGuides)
    func viewWillClose(userGuides: VFGUserGuides, page: VFGUserGuidesPage)
    func sectionActionRequested(userGuides: VFGUserGuides, page: VFGUserGuidesPage)
    func nextActionRequested(userGuides: VFGUserGuides, page: VFGUserGuidesPage)
}
