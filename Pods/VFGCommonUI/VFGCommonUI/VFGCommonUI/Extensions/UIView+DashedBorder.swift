//
//  UIView+DashedBorder.swift
//  VFGCommonUI
//
//  Created by Sandra Morcos on 12/30/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension UIView {
    public func addDashedBorder(color: UIColor,
                                lineWidth: CGFloat,
                                lineDashPattern: [NSNumber],
                                cornerRadius: CGFloat) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        layer.addSublayer(shapeLayer)
    }
}
