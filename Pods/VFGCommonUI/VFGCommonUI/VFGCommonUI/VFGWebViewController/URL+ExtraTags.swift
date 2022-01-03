//
//  URL+ExtraTags.swift
//  VFGCommonUI
//
//  Created by Esraa Eldaltony on 2/3/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension URL {

    public func paramsFromQuery() -> [String: String] {
        var trackViewDec: [String: String] = [:]
        if absoluteString.contains("?") {
            let pairs = absoluteString.components(separatedBy: "?")
            if  pairs.count > 0 {
                let params = pairs[1].components(separatedBy: "&")
                if  params.count > 0 {
                    for paramPair in params {
                        let vars = paramPair.components(separatedBy: "=")
                        trackViewDec[vars[0]] = vars[1]
                    }
                }
            }
        }
        return trackViewDec
    }

}
