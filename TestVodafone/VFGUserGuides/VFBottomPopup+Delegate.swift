//
//  VFBottomPopup+Delegate.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

typealias VFBottomPresentableViewController = VFBottomPopupAttributesDelegate & UIViewController

public protocol VFBottomPopupDelegate: class {
    func bottomPopupViewLoaded()
    func bottomPopupWillAppear()
    func bottomPopupDidAppear()
    func bottomPopupWillDismiss()
    func bottomPopupDidDismiss()
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public protocol VFBottomPopupAttributesDelegate: class {
    func getPopupHeight() -> CGFloat
    func getPopupTopCornerRadius() -> CGFloat
    func getPopupPresentDuration() -> Double
    func getPopupDismissDuration() -> Double
    func shouldPopupDismissInteractivelty() -> Bool
    func shouldPopupViewDismissInteractivelty() -> Bool
    func getDimmingViewAlpha() -> CGFloat
}

let VFDefaultHeight: CGFloat = 400.0
let VFDefaultSmallHeight: CGFloat = 300.0
let VFDefaultTopCornerRadius: CGFloat = 6.0
let VFDefaultPresentDuration = 0.5
let VFDefaultDismissDuration = 0.35
let dismissInteractively = true
let shouldPopupViewDismiss = false
let VFDimmingViewDefaultAlphaValue: CGFloat = 0.6

public struct ConfigurationBottomOverlayModel {
    var contentModel: BottomOverlayContentModel?
    var appearanceModel: BottomOverlayAppearanceModel?
    init() {
        contentModel = nil
        appearanceModel = nil
    }
}

public struct BottomOverlayContentModel {
    var attributedTitle: NSAttributedString?
    var attributedDescription: NSAttributedString?
    var primaryBtnText: String?
    var secondaryBtnText: String?
    var image: UIImage?
    var imageUrl: URL?
    init() {
        attributedTitle = nil
        attributedDescription = nil
        primaryBtnText = nil
        secondaryBtnText = nil
        imageUrl = nil
        image = nil
    }
}

public struct BottomOverlayAppearanceModel {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var shouldPopupViewDismiss: Bool?
    var fullScreen: Bool?
    init() {
        height = nil
        topCornerRadius = nil
        presentDuration = nil
        dismissDuration = nil
        shouldDismissInteractivelty = nil
        shouldPopupViewDismiss = nil
        fullScreen = nil
    }
}
enum NavigationMode {
    case normal(controller: UIViewController)
    case push(controller: UIViewController)
}
extension NavigationMode {
    var controller: UIViewController {
        switch self {
        case .normal(let controller):
            return controller
        case .push(let controller):
            return UINavigationController(rootViewController: controller)
        }
    }
}
