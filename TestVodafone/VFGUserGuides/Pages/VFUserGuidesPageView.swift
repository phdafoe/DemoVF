//
//  VFFTEPageView.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 24/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit
import VFGCommonUI


class VFUserGuidesPageView: UIScrollView {
    var containerView: UIView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var imageView: UIImageView
    var descriptionLabel: UILabel
    var imageHeightConstraint: NSLayoutConstraint?
    unowned let page: UserGuidesPage

    init(frame: CGRect, page: UserGuidesPage) {
        self.page = page
        self.containerView = UIView()
        self.titleLabel = UILabel()
        self.subtitleLabel = UILabel()
        self.imageView = UIImageView()
        self.descriptionLabel = UILabel()
        super.init(frame: frame)
        configure()
        applyModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func applyModel() {
        let titleFont = "\(UIFont.vodafoneRegularFont(<#T##fontSize: CGFloat##CGFloat#>))"
        var html = page.title.convertToHtml(fontSize: 32, fontSizeType: .pixel, fontName: titleFont, color: .darkGray)
        titleLabel.attributedText = html
        let fontName = "vodafone-regular"
        html = page.subtitle.convertToHtml(fontSize: 20, fontSizeType: .pixel, fontName: fontName, color: .darkGray)
        subtitleLabel.attributedText = html
        let description = page.details ?? ""
        descriptionLabel.isHidden = description.isEmpty
        html = description.convertToHtml(fontSize: 20, fontSizeType: .point, fontName: fontName, color: .darkGray)
        descriptionLabel.attributedText = html
        layoutIfNeeded()
        let url = page.imageURL
        if let urlR = url {
            DispatchQueue.global().async {
                guard  let data = try? Data(contentsOf: urlR) else { self.imageView.isHidden = true
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                    self.onImageFetched(self.imageView.image ?? UIImage())
                }
            }
        }
    }

    private func onImageFetched(_ image: UIImage) {
        let aspectRatio = image.size.height / image.size.width
        imageHeightConstraint?.isActive = false
        let width = imageView.widthAnchor
        imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: width, multiplier: aspectRatio)
        imageHeightConstraint?.isActive = true
        layoutIfNeeded()
    }
}
