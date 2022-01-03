//
//  VFGScrollableTabBarItem.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 3/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

@objc public enum VFGScrollableTabBarItemStatus: Int {
    case enabled
    case selected
    case disabled
}

@objc open class VFGScrollableTabBarItem: NSObject {

    @objc public var title: String?
    @objc public var image: UIImage?  //this var will be always read by the scrollableTabbar view.
    @objc public var viewController: UIViewController?
    @objc public var status: VFGScrollableTabBarItemStatus = .enabled
    //the image for icon in normal state.. for that case not having notification.
    @objc public var normalImage: UIImage?
    @objc public var notificationImage: UIImage?  //the image for icon in notification state.

    // this variable will indicate if the current item is being displayed in notification mode or not.
    // it also contains a didSet which automatically changes the image var to the associated icon relative to the mode.

    private var hasNewNotification: Bool = false {
        didSet {
            if hasNewNotification {
                image = notificationImage
            } else {
                image = normalImage
            }
        }

    }

    @objc public convenience init(withTitle title: String?, image: UIImage?, viewController: UIViewController?) {
        self.init(withTitle: title, image: image, status: .enabled)
        self.viewController = viewController

    }

    @objc public convenience init(withTitle title: String?, image: UIImage?) {
        self.init(withTitle: title, image: image, status: .enabled)
    }

    //new initalizer takes NotificationImage as a new parameter, the notificationImage are supposed to
    // be the image which will displayed if the item in notification mode.
    @objc public convenience init(withTitle title: String?, image: UIImage?, notificationImage: UIImage?) {
        self.init(withTitle: title, image: image, status: .enabled)
        self.notificationImage = notificationImage
    }

    @objc public init(withTitle title: String?, image: UIImage?, status: VFGScrollableTabBarItemStatus) {

        self.title = title
        self.image = image
        self.normalImage = image

        self.status = status
    }

    @objc public func switchToNewNotificationMode(hasNewNotification: Bool) {
        self.hasNewNotification = hasNewNotification
    }

    @objc public func itemIconIsNewNotification() -> Bool {
        return hasNewNotification
    }

}
