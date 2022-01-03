//
//  VFGNavigationController.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 4/28/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/*
 Vodafone navigation controller that uses generic custom animation transition and background logic
 across all Vodafone apps
 */
@objc open class VFGNavigationController: UINavigationController {

    private static let morningLevelOneImageName: String = "morning_bg"
    private static let morningLevelTwoImageName: String = "morning_sl"
    private static let eveningLevelOneImageName: String = "evening_bg"
    private static let eveningLevelTwoImageName: String = "evening_sl"

    private var fadingOutBackgroundImageView = UIImageView()
    private var fadingInBackgroundImageView = UIImageView()

    /**
     a boolean for enable night mode for the navigation controller
     */
    @objc open var nightMode: Bool = UserDefaults.standard.nightMode

    /**
     a boolean for enable background animation in transation
     */
    @objc open var backGroundAnimation: Bool = true
    /**
     Custom background image for the navigation controller
     */
    @objc open var backgroundImage: UIImage? {
        didSet {
            displayedBackgroundImage = backgroundImage
        }
    }

    /**
     Default morning image for first level view controller
     */
    @objc open var morningLevelOneImage: UIImage? = {
        return UIImage(named: morningLevelOneImageName, in: Bundle.vfgCommonUI, compatibleWith: nil)
    }()

    /**
     Default morning image for second level view controllers
     */
    @objc open var morningLevelTwoImage: UIImage? = {
        return UIImage(named: morningLevelTwoImageName, in: Bundle.vfgCommonUI, compatibleWith: nil)
    }()

    /**
     Default evening image for first level view controller
     */
    @objc open var eveningLevelOneImage: UIImage? = {
        return UIImage(named: eveningLevelOneImageName, in: Bundle.vfgCommonUI, compatibleWith: nil)
    }()

    /**
     Default evening image for second level view controllers
     */
    @objc open var eveningLevelTwoImage: UIImage? = {
        return UIImage(named: eveningLevelTwoImageName, in: Bundle.vfgCommonUI, compatibleWith: nil)
    }()

    fileprivate var displayedBackgroundImage: UIImage? {
        willSet (newValue) {
            if self.displayedBackgroundImage != newValue {
                if self.displayedBackgroundImage != nil {
                    VFGDebugLog("Replacing previous displayBackgroundImage property")

                    self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    self.fadingOutBackgroundImageView.alpha = 1

                    self.fadingInBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.alpha = 0
                    if backGroundAnimation {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.fadingInBackgroundImageView.alpha = 1
                    }, completion: { (_) in
                        self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    })
                    } else {
                      self.fadingInBackgroundImageView.alpha = 1
                         self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    }
                } else {
                    VFGDebugLog("Configuring new displayBackgroundImage property")

                    self.fadingOutBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.image = newValue
                }
            }
        }
    }

    // MARK: Setup
    private func setupBackground() {
        fadingInBackgroundImageView.frame = view.bounds
        fadingInBackgroundImageView.alpha = 0

        fadingOutBackgroundImageView.frame = view.bounds
        fadingOutBackgroundImageView.alpha = 1

        view.addSubview(fadingInBackgroundImageView)
        view.addSubview(fadingOutBackgroundImageView)
        view.sendSubviewToBack(fadingInBackgroundImageView)
        view.sendSubviewToBack(fadingOutBackgroundImageView)
        updateBackgroundFor(viewControllers: viewControllers)
    }

    // MARK: - UIViewController

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupBackground()
    }

    // MARK: - UINavigationController

    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        self.updateBackgroundFor(viewControllers: viewControllers)
    }

    // MARK: - Background Logic

    fileprivate func updateBackgroundFor(viewControllers: [UIViewController]) {
        if self.backgroundImage == nil {
            VFGDebugLog("BackgroundImage is nil")
            //Transitioning to level 1
            if viewControllers.count < 2 {
                VFGDebugLog("Setting level 1 default background image")
                self.displayedBackgroundImage = self.levelOneDefaultBackgroundImage()
            } else {
                //Transitioning to level 2+
                VFGDebugLog("Setting level 2 default background image")
                self.displayedBackgroundImage = self.levelTwoDefaultBackgroundImage()
            }
        } else {
            //Use overriding VC background image
            self.displayedBackgroundImage = self.backgroundImage
        }
    }

    private func levelOneDefaultBackgroundImage() -> UIImage? {
        self.updateNightMode()
        return self.nightMode ? self.eveningLevelOneImage : self.morningLevelOneImage
    }

    private func levelTwoDefaultBackgroundImage() -> UIImage? {
        self.updateNightMode()
        return self.nightMode ? self.eveningLevelTwoImage : self.morningLevelTwoImage
    }

    private func updateNightMode() {
        nightMode = UserDefaults.standard.nightMode
    }
}

// MARK: - UINavigationControllerDelegate

extension VFGNavigationController: UINavigationControllerDelegate {

    @objc public func navigationController(_ navigationController: UINavigationController,
                                           animationControllerFor operation: UINavigationController.Operation,
                                           from fromVC: UIViewController,
                                           to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.updateBackgroundFor(viewControllers: self.viewControllers)

        let animation = VFGNavigationViewControllerAnimator()
        animation.isPush = (operation == .push)
        return animation
    }
}
