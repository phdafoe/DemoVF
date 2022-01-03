//
//  VFGBubbleLoadingIndicator.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 10/3/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import Lottie

public class VFGBubbleLoadingIndicator: UIView {
    var lottieView: AnimationView

    init () {
        lottieView = AnimationView()
        super.init(frame: CGRect.zero)
    }

    convenience init(_ strokeColor: BubbleStrokeColor = .grey,
                     bubbleSize: BubbleSize = .tiny,
                     backgroundColor: UIColor = UIColor.clear) {
        self.init()
        constructLoadingBubbleViewWith(strokeColor, bubbleSize: bubbleSize)
        frame = lottieView.frame
        addSubview(lottieView)
        self.backgroundColor = backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        lottieView = AnimationView()
        super.init(coder: aDecoder)
    }

    internal func constructLoadingBubbleViewWith(_ strokeColor: BubbleStrokeColor, bubbleSize: BubbleSize) {
        let name: String = getFileNameForAnimation(strokeColor, bubbleSize: bubbleSize)
        lottieView = AnimationView(name: name, bundle: Bundle.vfgCommonUI)
        lottieView.loopMode = .loop
    }

    // MARK: - private methods
    internal func getFileNameForAnimation(_ strokeColor: BubbleStrokeColor = .grey,
                                          bubbleSize: BubbleSize = .tiny) -> String {
        let prefix = "vf_spinner_"
        let colorFile = prefix + "\(strokeColor.rawValue)_\(bubbleSize.rawValue)"
        return colorFile
    }

    public func play() {
        lottieView.play()
    }

    public func stop() {
        lottieView.stop()
    }
}
