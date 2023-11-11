//
//  NIVectorModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/07.
//

import Foundation
import NearbyInteraction

class NIVectorModel {
    var niDiscoveryToken: NIDiscoveryToken!
    var vector: simd_float3
    
    init(niDiscoveryToken: NIDiscoveryToken!,  x: Float, y: Float, z: Float) {
        self.niDiscoveryToken = niDiscoveryToken
        self.vector = simd_float3(x: x, y: y, z: z)
    }
    
    init(niDiscoveryToken: NIDiscoveryToken!,  vector: simd_float3) {
        self.niDiscoveryToken = niDiscoveryToken
        self.vector = vector
    }

    
    init(x: Float, y: Float, z: Float) {
        self.niDiscoveryToken = nil
        self.vector = simd_float3(x: x, y: y, z: z)
    }
    
    init(vector: simd_float3) {
        self.niDiscoveryToken = nil
        self.vector = vector
    }
    
    init() {
        self.niDiscoveryToken = nil
        self.vector = simd_float3(x: 0, y: 0, z: 0)
    }
    
    func angleBetweenVectors(referenceVector: NIVectorModel) -> Float {
        let dotProduct = simd_dot(self.vector, referenceVector.vector)
        let magnitudeProduct = simd_length(self.vector) * simd_length(referenceVector.vector)
        return acos(dotProduct / magnitudeProduct)
    }
    
}
