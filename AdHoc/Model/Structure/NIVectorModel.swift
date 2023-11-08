//
//  NIVectorModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/07.
//

import Foundation
import NearbyInteraction

class NIVectorModel : VectorModel {
    var niDiscoveryToken: NIDiscoveryToken!
    
    init(niDiscoveryToken: NIDiscoveryToken!,  x: Float, y: Float, z: Float) {
        self.niDiscoveryToken = niDiscoveryToken
        super.init(x: x, y: y, z: z)
    }
}
