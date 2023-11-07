//
//  VectorModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation

class VectorModel {
    var x: Float
    var y: Float
    var z: Float
    
    // MARK: - Init
    init(){
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func normalize() {
        var distance: Float
        distance = sqrtf(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2))
        self.x /= distance
        self.y /= distance
        self.z /= distance
    }
    
    func multiplyByScalars(scalar: Float) {
        self.x *= scalar
        self.y *= scalar
        self.z *= scalar
    }
    
    func dotProduct(other: VectorModel) -> Float {
        return self.x*other.x + self.y*other.y + self.z*other.z
    }
    
    func crossProduct(other: VectorModel) -> VectorModel {
        let c_x: Float = self.y*other.z - self.z*other.y
        let c_y: Float = self.z*other.x - self.x*other.z
        let c_z: Float = self.x*other.y - self.y*other.x
        return VectorModel(x: c_x, y: c_y, z: c_z)
    }
}
