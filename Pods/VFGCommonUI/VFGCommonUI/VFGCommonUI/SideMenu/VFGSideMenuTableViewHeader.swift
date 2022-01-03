//
//  VFGSideMenuTableViewHeader.swift
//  VFGCommonUI
//
//  Created by Mohamed Matloub on 3/5/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit

class VFGSideMenuTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var itemView: VFGSideMenuItemView!
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        itemView.selectedCellWhiteView.isHidden = true
    }
}
