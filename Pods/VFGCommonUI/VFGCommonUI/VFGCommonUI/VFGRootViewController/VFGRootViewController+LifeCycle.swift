//
//  VFGRootViewController+LifeCycle.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 05/02/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFGRootViewController {

    /**
     Set root view controller which view is presented as first top screen.
     */
    @objc public func setRootViewController(_ viewController: UIViewController) {
        updateTopBarState()
        clearTopBarDelegate()
        containerNavigationController.setViewControllers([viewController], animated: false)
        navigationControllerCounter = 1
        updateTopBar(viewController)
        executeTransition()
        statusBarAlpha = 0
    }

    /**
     Push view controller on navigation stack
     */
    @objc public func pushViewController(_ viewController: UIViewController, animated: Bool,
                                         showNudge: Bool = VFGRootViewController.shared.shouldNudgeView) {
        shouldNudgePersist(showNudge)
        updateTopBarState()
        clearTopBarDelegate()
        navigationControllerCounter = containerNavigationController.viewControllers.count + 1
        containerNavigationController.pushViewController(viewController, animated: animated)
        updateTopBar(viewController)
        executeTransition()
        statusBarAlpha = 0
    }

    /**
     Present view controller
     */
    @objc public func presentViewController(_ viewController: UIViewController,
                                            animated: Bool,
                                            showNudge: Bool = false) {
        shouldNudgePersist(showNudge)
        present(viewController, animated: animated, completion: nil)
    }

    /**
     Pop view controller which is on top of navigation stack.
     */
    @objc public func popToRootViewController(animated: Bool) {
        let isOffsetEnabled = offsetEnabled()
        previousTopBarScrollState = nil
        shouldNudgePersist(shouldNudgeView)
        clearTopBarDelegate()
        containerNavigationController.popToRootViewController(animated: animated)
        navigationControllerCounter = 1
        updateTopBar(containerNavigationController.topViewController)
        topBarTransition(isOffsetEnabled)
    }

    /**
     Pop view controller which is on top of navigation stack.
     */
    @objc public func popViewController(animated: Bool) {
        let isOffsetEnabled = offsetEnabled()
        shouldNudgePersist(shouldNudgeView)
        clearTopBarDelegate()
        containerNavigationController.popViewController(animated: animated)
        navigationControllerCounter -= 1
        updateTopBar(containerNavigationController.topViewController)
        topBarTransition(isOffsetEnabled)
    }

    @objc public func showOnRootController(_ viewControllers: [UIViewController], animated: Bool) {
        showOnRootController(viewControllers, animated: animated, showNudge: shouldNudgeView)
    }

    /**
     Show view controllers on the top of root view controller
     */
    @objc public func showOnRootController(_ viewControllers: [UIViewController],
                                           animated: Bool,
                                           showNudge: Bool = false) {
        shouldNudgePersist(showNudge)
        let isOffsetEnabled = offsetEnabled()
        clearTopBarDelegate()

        let rootViewController: UIViewController? = containerNavigationController.viewControllers.first
        var presentedControllers: [UIViewController] = []

        if let controller = rootViewController {
            presentedControllers.append(controller)
        }
        presentedControllers.append(contentsOf: viewControllers)
        navigationControllerCounter = presentedControllers.count
        containerNavigationController.setViewControllers(presentedControllers, animated: animated)
        updateTopBar(viewControllers.last)
        topBarTransition(isOffsetEnabled)
        statusBarAlpha = 0
    }

    fileprivate func clearTopBarDelegate() {
        topBar.opaqueBackgroundAlpha = 0
        currentTopBarScrollState.topBar = nil
    }

    fileprivate func updateTopBarState() {
        previousTopBarScrollState = currentTopBarScrollState
    }

    fileprivate func executeTransition() {
        topBarTransition(previousTopBarScrollState?.isNoOffset)
    }

}
