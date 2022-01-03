//
//  VFGAnimations.swift
//  VFGBubbleAnimations
//
//  Created by Ahmed Elshobary on 03/27/17.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public extension CABasicAnimation {

    convenience init(forwardAnimationWithKeyPath keyPath: String) {
        self.init(keyPath: keyPath)
        isRemovedOnCompletion = false
        fillMode = CAMediaTimingFillMode.forwards
    }
}

public extension CAAnimationGroup {

    convenience init(forwardAnimationGroupWithDuration duration: Double, animations: [CAAnimation]) {
        self.init()
        isRemovedOnCompletion = false
        fillMode = CAMediaTimingFillMode.forwards
        self.duration = duration
        self.animations = animations
    }
}
