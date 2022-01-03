//
//  VFGViewControllerContent.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 05/02/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/**
 View controller implementing this protocol is added to VFGRootViewController and modifies appearance of components
 on the screen.
 Properties of this protocol modify behaviour of a top bar (VFGTopBar) .
 */
public protocol VFGViewControllerContent {

    /**
     State of a status bar when this view controller is presented.
     */
    var statusBarState: VFGRootViewControllerStatusBarState { get }

    /**
     Top bar scroll state used by top bar when this view controller is presented.
     */
    var topBarScrollState: VFGTopBarScrollState? { get }

    /**
     Title set on top bar when this view controller is presented.
     */
    var topBarTitle: String { get set }

    /**
     Bool for showing or hiding menu burger icon
     */
    var topBarRightButtonHidden: Bool { get set }

    /**
     topBar left icon color, optional property
      that if not setted the topbar will use the default
      leftIcon image inside commonUI component.
     */
    func leftButtonIconColor() -> UIColor?

    /**

    topBar right icon color, optional property that
     if not setted the topbar will use the default right
     image inside commonUI component.
    */
    func rightButtonIconColor() -> UIColor?

    /**
     Properties to set title font for topBar,
     if not set default values will be used related to vodafone group theme.
     */
    func titleFont() -> UIFont?

    /**
     Properties to set title color for topBar,
     if not set default values will be used related to vodafone group theme.
     */
    func titleColor() -> UIColor?

    /**
     Background color for not transparent top bar,
     if nil default will be used
     */
    func backgroundColor() -> UIColor?

    /**
     disable or enable Parrallax effect
     */
    func parallaxEffectEnabled() -> Bool
}

extension VFGViewControllerContent {
    public func leftButtonIconColor() -> UIColor? {
        return nil
    }

    public func rightButtonIconColor() -> UIColor? {
        return nil
    }

    public func titleFont() -> UIFont? {
        return nil
    }

    public func titleColor() -> UIColor? {
        return nil
    }

    public func backgroundColor() -> UIColor? {
        return nil
    }

    public func parallaxEffectEnabled() -> Bool {
        return true
    }
}
