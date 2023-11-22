//
//  ConvexHullModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/07.
//

import Foundation
import NearbyInteraction

class ConvexHullModel: NSObject {
    
    var niPoints: StackModel<NIVectorModel>
    var niConvexHull: StackModel<NIVectorModel>
    var niNotConvexHull: StackModel<NIVectorModel>
    
    
    init(niPoints: StackModel<NIVectorModel>) {
        self.niPoints = niPoints
        self.niConvexHull = StackModel(array: [])
        self.niNotConvexHull = StackModel(array: [])
    }
    
    override init(){
        self.niPoints = StackModel(array: [])
        self.niConvexHull = StackModel(array: [])
        self.niNotConvexHull = StackModel(array: [])
    }
    
    func appendPoint(niDiscoveryToken: NIDiscoveryToken!, x: Float, y: Float, z: Float){
        let niVec: NIVectorModel = NIVectorModel(niDiscoveryToken: niDiscoveryToken, x: x, y: y, z: z)
        self.niPoints.push(element: niVec)
    }
    
    func appendPoint(niVec: NIVectorModel){
        self.niPoints.push(element: niVec)
    }
    
    func calcConvexHull() {
        
        var smallestZPoint: NIVectorModel // a point with the smallest z axis
        var index: Int // for convex stack
        
        // Push a point with the smallest z axis into a stack of convex hull
        smallestZPoint = self.getPointWithTheSmallestZ()
        self.niConvexHull.push(element: smallestZPoint)
        
       //print("smallestZ OK")
        
        // Sort points in order of  the largest x axis.
        //self.changeReferencePoint(referencePoint: smallestZPoint)
        self.sortPointsByRefAngle(referenceVector: smallestZPoint)
        //print("sort OK")
        
     for point in self.niPoints.array {
         print("vec: (" + String(point.vector.x) + ", " + String(point.vector.y) + ", " + String(point.vector.z)  + ")  angle:" + String(point.angleBetweenVectorsOnXZPlane(referenceVector: NIVectorModel(x: 1, y: 0, z: 0))))
       }
        
        // Push points into a stack convex hull
        self.niConvexHull.pushArray(elements: self.niPoints.array)
        
        index = 0
        if(self.niConvexHull.size > 3){
            print("Convex calc")
            
            while(self.niConvexHull.size > index + 2) {
                
                if( isLeftTurn(vec1: self.niConvexHull.array[index].vector,
                               vec2: self.niConvexHull.array[index + 1].vector,
                               vec3: self.niConvexHull.array[index + 2].vector) ){
                    index += 1
                    print("indexNotChanged")
                }else {
                    self.niNotConvexHull.push(element: self.niConvexHull.array[index + 1])
                    self.niConvexHull.array.remove(at: index + 1)
                    print("indexChanged")
                    if index-1 >= 0 {
                        index -= 1
                    }
                }
            }
        }
        
        
    }
    
    func isLeftTurn(vec1: simd_float3, vec2: simd_float3, vec3: simd_float3)->Bool{
        
        let matrix: [[Float]] = [
            [vec1.x, vec2.x, vec3.x],
            [vec1.z, vec2.z, vec3.z],
            [1.0, 1.0, 1.0]
        ]
        
        var det: Float = 0
        
        print("array")
        print(matrix)
        
        det += matrix[0][0]*matrix[1][1]*matrix[2][2]
        det -= matrix[0][0]*matrix[1][2]*matrix[2][1]
        det += matrix[0][1]*matrix[1][2]*matrix[2][0]
        det -= matrix[0][1]*matrix[1][0]*matrix[2][2]
        det += matrix[0][2]*matrix[1][0]*matrix[2][1]
        det -= matrix[0][2]*matrix[1][1]*matrix[2][0]
    
        print("det: " + String(det))
        if(det>0){
            return true
        }else {
            return false
        }
    }
    
    func sortPointsByRefAngle(referenceVector: NIVectorModel) {
        
        self.niPoints.array.sort(by: {vector1, vector2 -> Bool in
            
            let normVec1: NIVectorModel  = NIVectorModel(vector: normalize(vector1.vector - referenceVector.vector) )
            let normVec2: NIVectorModel  = NIVectorModel(vector: normalize(vector2.vector - referenceVector.vector) )
            let normRefVec: NIVectorModel = NIVectorModel( vector:simd_float3(1, 0, 0) )
            
            return normVec1.angleBetweenVectorsOnXZPlane(referenceVector: normRefVec) < normVec2.angleBetweenVectorsOnXZPlane(referenceVector: normRefVec)
        })
    }
    
    func sortConvByX() {
        self.niConvexHull.array.sort(by: {a, b -> Bool in
            return a.vector.x > b.vector.x
        })
    }
    
    func changeReferencePoint(referencePoint: NIVectorModel){
        for (index, _) in self.niPoints.array.enumerated(){
            self.niPoints.array[index].vector -= referencePoint.vector
        }
    }
    
    func getPointWithTheSmallestZ() -> NIVectorModel{
        
        var smallestZPoint: NIVectorModel = NIVectorModel(niDiscoveryToken: nil, x: Float.infinity, y: Float.infinity, z: Float.infinity) // a point with the smallest z axis
        var smallestZIndex: Int = 0 // the index of a point with the smallest z axis
        
        // Find a point with the smallest z axis
        for (index, point) in self.niPoints.array.enumerated() {
            if point.vector.z < smallestZPoint.vector.z {
                smallestZPoint = point
                smallestZIndex = index
            }
        }
        
        // Delete the point from array
        //print("Index: " + String(smallestZIndex))
        //print("PointNum: " + String(self.niPoints.size))
        self.niPoints.array.remove(at: smallestZIndex)

        return smallestZPoint
    }
    
    func angleBetweenVectorsOnXZPlane(vec1: simd_float3, vec2: simd_float3) -> Float {
        let dotProduct = simd_dot(vec1, vec2)
        let magnitudeProduct = simd_length(vec1) * simd_length(vec2)
        return acos(dotProduct / magnitudeProduct)
    }
}
