//
//  SideMenuTableViewCell.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 09/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGSideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var itemView: VFGSideMenuItemView!
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        itemView.selectedCellWhiteView.isHidden = true
    }

}
