//
//  VectorModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation
import NearbyInteraction

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
    
    
    
    // MARK: - Functions for updating a vector
    func update(x: Float, y: Float, z: Float){
        self.x = x
        self.y = y
        self.z = z
    }
    
    func update(vec: SIMD3<Float>) {
        self.x = vec.x
        self.y = vec.y
        self.z = vec.z
    }
    
    //MARK: -Functions for vector calculatiion
    
    func add(x: Float, y: Float, z: Float){
        self.x += x
        self.y += y
        self.z += z
    }
    
    func add(vec: VectorModel){
        self.add(x: vec.x, y: vec.y, z: vec.z)
    }
    
    func subtract(x: Float, y: Float, z: Float){
        self.add(x: -x, y: -y, z: -z)
    }
    
    func subtract(vec: VectorModel){
        self.subtract(x: vec.x, y: vec.y, z: vec.z)
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
