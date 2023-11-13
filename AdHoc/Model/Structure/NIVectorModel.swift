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
    
    func angleBetweenVectorsOnXZPlane(referenceVector: NIVectorModel) -> Float {
        let myVec2: simd_float2 = simd_float2(self.vector.x, self.vector.z)
        let refVec2: simd_float2 = simd_float2(referenceVector.vector.x, referenceVector.vector.z)
        let dotProduct = simd_dot(myVec2, refVec2)
        let magnitudeProduct = simd_length(myVec2) * simd_length(refVec2)
        return acos(dotProduct / magnitudeProduct)
    }
    
}
