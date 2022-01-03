//
//  VFGBubbleLoadingIndicatorBuilder.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 10/3/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
public enum BubbleStrokeColor: String {
    case grey
    case red
    case white
}
public enum BubbleSize: String {
    case tiny = "tiny_30"
    case small = "small_75"
    case medium = "medium_150"
    case large = "large_300"
}

public class VFGBubbleLoadingIndicatorBuilder: NSObject {
    public var backgroundColor: UIColor = UIColor.clear
    public var strokeColor: BubbleStrokeColor = .grey
    public var size: BubbleSize = .tiny
    public var loadingIndicatorBubble: VFGBubbleLoadingIndicator {
        return VFGBubbleLoadingIndicator(strokeColor, bubbleSize: size, backgroundColor: backgroundColor)
    }
    public override init() {
        super.init()
    }
    convenience init(_ strokeColor: BubbleStrokeColor, bubbleSize: BubbleSize, backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.size = bubbleSize
    }

}
