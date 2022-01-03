//
//  UIImage+bundle.swift
//  VFGProductsServices
//
//  Created by Lukasz Lewinski on 09/03/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

struct BundleImage: _ExpressibleByImageLiteral {
    let image: UIImage

    init(imageLiteralResourceName name: String) {
        image = UIImage(named: name, in: Bundle.vfgCommonUI, compatibleWith: nil)!
    }
}
extension UIImage {
    static func fromBundleImage(_ bundleImage: BundleImage) -> UIImage {
        return bundleImage.image
    }
}
