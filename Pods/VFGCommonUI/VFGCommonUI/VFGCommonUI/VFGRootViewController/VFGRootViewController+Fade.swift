//
//  VFGRootViewController+Fade.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 28/11/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

extension VFGRootViewController {

    @objc public func fadeInOverlay(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.blackOverlayView.alpha = 1
        }
    }

    @objc public func fadeOutOverlay(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.blackOverlayView.alpha = 0
        }
    }

}
