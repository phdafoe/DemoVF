//
//  ChiphedView.swift
//  VFGReferenceApp
//
//  Created by Michał Kłoczko on 18/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc open class VFGChippedView: UIView {

    @objc public var chipHeight: CGFloat = 0 {
        didSet {
            if oldValue != chipHeight {
                VFGDebugLog("Updating chip height:\(chipHeight)")
                self.setNeedsLayout()
            }
        }
    }

   @objc override  open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.mask = self.makeChippedShape(chipHeight: self.chipHeight, shapeRect: self.bounds)
    }

    private func makeChippedShape(chipHeight: CGFloat, shapeRect: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = CGPath.chipped(chipHeight: chipHeight, shapeRect: shapeRect)
        return shapeLayer
    }

}
