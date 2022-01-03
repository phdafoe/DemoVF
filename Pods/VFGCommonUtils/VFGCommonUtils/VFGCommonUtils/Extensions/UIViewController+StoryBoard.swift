//
//  UIViewController+StoryBoard.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 30/09/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension UIViewController {

    public class func viewController<T: UIViewController>(from storyboardName: String,
                                                          with identifier: String = String("\(T.self)"),
                                                          bundle: Bundle? = nil) -> T {
        // if storyboard with storyboardName doesn't exist or bundle doesn't contain storyboard then init
        // of UIStoryboard will throw NSException
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let storyboardVC = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            VFGErrorLog("Can't init \(T.self) with \(storyboardName):\(identifier) using \(T.self)()")
            return T()
        }
        return storyboardVC
    }

}
