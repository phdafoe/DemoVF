//
//  Bundle+Init.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 16/05/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension Bundle {
    private class VFGExample {}

    public class var foundation: Bundle {
        return Bundle(for: VFGExample.self)
    }

   
}
