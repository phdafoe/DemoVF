//
//  VFGChippedShadowView.swift
//  VFGReferenceApp
//
//  Created by Michał Kłoczko on 18/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

enum VFGChippedShadowViewConstant {
    case arrowChippedValue

    func value () -> CGFloat {
        switch self {
        case .arrowChippedValue:
            if UIScreen.isIpad {
                return 15
            }
            return 10
        }
    }

}

@objc public class VFGChippedShadowView: UIView {

    @objc public var visibleBackgroundColor: UIColor? {
        get {
            return self.chippedView.backgroundColor
        }
        set {
            self.chippedView.backgroundColor = newValue
        }
    }

    private var shadowView: VFGShadowView!
    private var chippedView: VFGChippedView!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    lazy var oldBounds: CGRect = bounds
    public override var bounds: CGRect {
        didSet {
            if oldValue.height < bounds.height {
                oldBounds = bounds
            }
        }
    }
    public override var frame: CGRect {
        didSet {
            if oldValue.height < frame.height {
                oldBounds = bounds
            }
        }
    }
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        self.shadowView = VFGShadowView(frame: CGRect.zero)
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.shadowView)

        self.chippedView = VFGChippedView(frame: CGRect.zero)
        self.chippedView.translatesAutoresizingMaskIntoConstraints = false
        self.chippedView.backgroundColor = UIColor.VFGChippViewBackground
        self.addSubview(self.chippedView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.chippedView.chipHeight = VFGChippedShadowViewConstant.arrowChippedValue.value()
        self.shadowView.chipHeight = VFGChippedShadowViewConstant.arrowChippedValue.value()

        self.chippedView.frame = self.oldBounds
        self.shadowView.frame = self.shadowViewFrame()
    }

    private func shadowViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0,
                      width: self.bounds.width, height: VFGChippedShadowViewConstant.arrowChippedValue.value())
    }

}
