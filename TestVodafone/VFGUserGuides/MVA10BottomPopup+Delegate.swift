//
//  VFBottomPopup+Delegate.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

public typealias MVA10BottomPresentableViewController = MVA10BottomPopupAttributesProtocol & UIViewController

public protocol MVA10BottomPopupDelegate: class {
    /// Notifies the view controller that its view was added to a view hierarchy.
    func bottomPopupViewLoaded()
    /// Notifies the view controller that its view is going to be added to a view hierarchy.
    func bottomPopupWillAppear()
    /// Notifies the view controller that its view was added to a view hierarchy.
    func bottomPopupDidAppear()
    /// Notifies the view controller that its view is going to be removed from a view hierarchy.
    func bottomPopupWillDismiss()
    /// Notifies the view controller that its view is removed from a view hierarchy.
    func bottomPopupDidDismiss()
    /// Notifies that the interaction percent has changed.
    func bottomPopupDismissInteraction(didChangedPercentFrom oldValue: CGFloat, to newValue: CGFloat)
}

public extension MVA10BottomPopupDelegate {
    func bottomPopupViewLoaded() { }
    func bottomPopupWillAppear() { }
    func bottomPopupDidAppear() { }
    func bottomPopupWillDismiss() { }
    func bottomPopupDidDismiss() { }
    func bottomPopupDismissInteraction(didChangedPercentFrom oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol MVA10BottomPopupAttributesProtocol: class {
    /// Called when height of overlay is needed
    ///
    /// - Returns: overlay height
    func getPopupHeight() -> CGFloat
    /// Called when width of overlay is needed
    ///
    /// - Returns: overlay width
    func getPopupWidth() -> CGFloat
    /// Called when need to know the duration of presenting animation
    ///
    /// - Returns: present animation duration
    func getPopupPresentDuration() -> Double
    /// Called when need to know the duration of dismissing animation
    ///
    /// - Returns: dismiss animation duration
    func getPopupDismissDuration() -> Double
    /// Notifies if overlay can be dismissed by dragging
    ///
    /// - Returns: true if it can be dismissed by dragging
    func shouldPopupDismissInteractivelty() -> Bool
    /// Notifies if overlay can be dismissed by tapping on dimmed view
    ///
    /// - Returns: true if it can be dismissed by tapping on dimmed view
    func shouldPopupViewDismissInteractivelty() -> Bool
    /// Notifies the alpha value for dimmed view
    ///
    /// - Returns: dimmed view alpha value
    func getDimmingViewAlpha() -> CGFloat
    /// Notifies the color value for dimmed view background
    ///
    /// - Returns: dimmed view background color value
    func getDimmingViewBackgroundColor() -> UIColor
}

public extension MVA10BottomPopupAttributesProtocol {
    func getPopupHeight() -> CGFloat { return 400.0 }
    func getPopupWidth() -> CGFloat { return kPopupWidth }
    func getPopupPresentDuration() -> Double { return kPopupPresentDuration }
    func getPopupDismissDuration() -> Double { return kPopupDismissDuration }
    func shouldPopupDismissInteractivelty() -> Bool { return kPopupDismissInteractively }
    func shouldPopupViewDismissInteractivelty() -> Bool { return kPopupShouldPopupViewDismiss }
    func getDimmingViewAlpha() -> CGFloat { return kPopupDefaultAlphaValue }
    func getDimmingViewBackgroundColor() -> UIColor { return kPopupDefaultBackgroundColorValue }
}

    /// Default value for bottom popup height. 400pt
public let kPopupHeight: CGFloat = 400.0
    /// Default value for bottom popup width. Screen width
    public  let kPopupWidth: CGFloat = { return UIScreen.main.bounds.width }()
    /// Default value for bottom popup corner radius. 10pt
    public  let kPopupCornerRadius: CGFloat = 10.0
    ///  value for bottom popup present animation. 0.5seg
    public  let kPopupPresentDuration = 0.5
    /// Default value for bottom popup dismiss animation. 0.5seg
    public  let kPopupDismissDuration = 0.35
    /// Default value for bottom popup dismiss drag interaction. True
    public  let kPopupDismissInteractively = true
    /// Default value for bottom popup dismiss tap interaction. True
    public  let kPopupShouldPopupViewDismiss = true
    /// Default value for dimmed view alpha value. 0.6
    public  let kPopupDefaultAlphaValue: CGFloat = 0.6
    /// Default value for dimmed view background color black
    public  let kPopupDefaultBackgroundColorValue: UIColor = .black
