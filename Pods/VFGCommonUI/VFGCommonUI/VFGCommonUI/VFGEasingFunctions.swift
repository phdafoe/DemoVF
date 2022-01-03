//
//  VFGEasingFunctions.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 4/30/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public extension CAMediaTimingFunction {

    @objc static var easeInSine: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
    }

    @objc static var easeOutSine: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
    }

    @objc static var easeInOutSine: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
    }

    @objc static var easeInQuad: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
    }

    @objc static var easeOutQuad: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
    }

    @objc static var easeInOutQuad: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
    }

    @objc static var easeInCubic: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
    }

    @objc static var easeOutCubic: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
    }

    @objc static var easeInOutCubic: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
    }

    @objc static var easeInQuart: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
    }

    @objc static var easeOutQuart: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
    }

    @objc static var easeInOutQuart: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
    }

    @objc static var easeInQuint: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
    }

    @objc static var easeOutQuint: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
    }

    @objc static var easeInOutQuint: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
    }

    @objc static var easeInExpo: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
    }

    @objc static var easeOutExpo: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
    }

    @objc static var easeInOutExpo: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
    }

    @objc static var easeInCirc: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
    }

    @objc static var easeOutCirc: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
    }

    @objc static var easeInOutCirc: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
    }

    @objc static var easeInBack: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
    }

    @objc static var easeOutBack: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
    }

    @objc static var easeInOutBack: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
    }

}
