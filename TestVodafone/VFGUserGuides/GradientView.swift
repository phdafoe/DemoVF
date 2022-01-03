//
//  GradientView.swift
//  PreviewApp
//
//  Created by Alberto García-Muñoz on 03/07/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import UIKit

typealias GradientColors = [CGColor]
typealias GradientLocations = [NSNumber]

class GradientView: UIView {
    var locations: GradientLocations {
        didSet { setupView() }
    }
    var colors: GradientColors {
        didSet { setupView() }
    }
    var startPosition: CGPoint {
        didSet { setupView() }
    }
    var endPosition: CGPoint {
        didSet { setupView() }
    }

    init(frame: CGRect, colors: GradientColors, locations: GradientLocations, startPosition: CGPoint = CGPoint(x: 0.5, y: 0), endPosition: CGPoint = CGPoint(x: 0.5, y: 1)) {
        self.colors = colors
        self.locations = locations
        self.startPosition = startPosition
        self.endPosition = endPosition
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        self.colors = []
        self.locations = []
        self.startPosition = CGPoint(x: 0.5, y: 0)
        self.endPosition = CGPoint(x: 0.5, y: 1)
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors
        layer?.locations = locations
        layer?.frame = self.bounds
        layer?.startPoint = startPosition
        layer?.endPoint = endPosition
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
