//
//  UIViewController+FitSize.swift
//  VFGCommonUI
//
//  Created by Mohamed Abd ElNasser on 3/21/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIView {
    public func fitSize(to view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
