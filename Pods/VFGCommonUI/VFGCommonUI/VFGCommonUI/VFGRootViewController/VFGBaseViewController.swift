//
//  VFGBaseViewController.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout
import VFGCommonUtils

@objc open class VFGBaseViewController: UIViewController, VFGViewProtocol {

    // MARK: - Instance Variables
    var loadingIndicator: VFGLoadingIndicator?

    @objc override open func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = VFGLoadingIndicator(frame: CGRect.zero, loadingMessage: "Loading...")
        setupLoadingFrame()
    }
    /**
     Set loading message of the loading indicator
     - Parameter message: the message to be shown
     */
    @objc open func setLoadingMessage(_ message: String) {
        loadingIndicator?.setLoadingMessage(message)
    }
    /**
     Shows loading indicator on the view
     */
    @objc open func showLoadingIndicator() {
        guard let indicator = loadingIndicator else {
            VFGErrorLog("Loading indicator error")
            return
        }
        self.view.addSubview(indicator)
    }

    @objc open func showLoadingIndicator(backgroundImage: UIImage?, backgroundColor: UIColor = .gray) {
        guard let indicator = loadingIndicator else {
            VFGErrorLog("Loading indicator error")
            return
        }

        view.addSubview(indicator)
        indicator.backgroundColor = backgroundColor
        indicator.isHidden = false

        guard let image: UIImage = backgroundImage else {
            return
        }

        let backgroundImageView: UIImageView = UIImageView(image: image)
        indicator.addSubview(backgroundImageView)
        indicator.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        let top = NSLayoutConstraint(item: backgroundImageView,
                                     attribute: .top,
                                     toItem: loadingIndicator,
                                     attribute: .top,
                                     constant: 0)

        let bottom = NSLayoutConstraint(item: backgroundImageView,
                                        attribute: .bottom,
                                        toItem: loadingIndicator,
                                        attribute: .bottom,
                                        constant: 0)

        let leading = NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .leading,
                                         toItem: loadingIndicator,
                                         attribute: .leading,
                                         constant: 0)

        let trailing = NSLayoutConstraint(item: backgroundImageView,
                                          attribute: .trailing,
                                          toItem: loadingIndicator,
                                          attribute: .trailing,
                                          constant: 0)
        indicator.addConstraints([top, bottom, trailing, leading])
    }
    /**
     Hides the loading indicator from the view
     */
    @objc open func hideLoadingIndicator() {
        loadingIndicator?.removeFromSuperview()
    }

    /**
     Updates loading indicator's label position relative to the spinner
     - Parameter position: takes a value .top or .bottom to update the text position
                 (Only Top and Botton positions are supported)
     */
    @objc open func updateLoadingIndicatorLabelPosition(position: ALEdge) {
        loadingIndicator?.updateTextPositionTo(position: position)
    }

    private func setupLoadingFrame() {
        if isTopBarVisible() {
            let verticalPosition = VFGTopBar.topBarHeight + VFGCommonUISizes.statusBarHeight
            loadingIndicator?.frame = CGRect(x: view.frame.origin.x,
                                             y: verticalPosition,
                                             width: view.frame.size.width,
                                             height: view.frame.size.height - verticalPosition)
        } else {
            loadingIndicator?.frame = CGRect(x: view.frame.origin.x,
                                             y: view.frame.origin.y,
                                             width: view.frame.size.width,
                                             height: view.frame.size.height)
        }

    }

    private func isTopBarVisible() -> Bool {
        if let rootNavigation = VFGRootViewController.shared.containerNavigationController {
            return rootNavigation.viewControllers.count > 1
        }
        return false
    }
}
