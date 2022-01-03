//
//  VFGAlertViewController+ConfigureIcon.swift
//  VFGCommonUI
//
//  Created by Mohamed Abd ElNasser on 4/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFGAlertViewController {
    func configureIcon(_ iconImage: UIImage?) {
        guard let iconImage = iconImage else {
            iconHeight.constant = 0
            return
        }
        iconHeight.constant = 120
        icon.image = iconImage
    }
}
