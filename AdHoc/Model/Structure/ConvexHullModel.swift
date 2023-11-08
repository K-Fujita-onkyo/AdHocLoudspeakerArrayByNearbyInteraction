//
//  ConvexHullModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/07.
//

import Foundation
import NearbyInteraction

class ConvexHullModel: NSObject {
    
    var points: StackModel<NIVectorModel>
    var convexHull: StackModel<NIVectorModel>
    
    init(points: StackModel<NIVectorModel>) {
        self.points = points
        self.convexHull  = StackModel(array: [])
    }
    
    override init(){
        self.points = StackModel(array: [])
        self.convexHull = StackModel(array: [])
    }
    
    func append(niDiscoveryToken: NIDiscoveryToken, x: Float, y: Float, z: Float){
        let niVec: NIVectorModel = NIVectorModel(niDiscoveryToken: niDiscoveryToken, x: x, y: y, z: z)
        self.points.push(element: niVec)
    }
    
    func calcConvexHull() {
        
        var smallestZPoint: NIVectorModel // a point with the smallest z axis
        var index: Int // for convex stack
        
        // Push a point with the smallest z axis into a stack of convex hull
        smallestZPoint = self.getPointWithTheSmallestZ()
        self.convexHull.push(element: smallestZPoint)
        
        // Sort points in order of  the largest x axis.
        self.changeReferencePoint(refelencePoint: smallestZPoint)
        self.sortPoints()
        
        // Push points into a stack convex hull
        self.convexHull.pushArray(elements: self.points.array)
        
        index = 0
        while(self.convexHull.size <= index + 2) {
            
            if( isLeftTurn(vec1: self.convexHull.array[index],
                                  vec2: self.convexHull.array[index+1],
                                  vec3: self.convexHull.array[index+2]) ){
                index += 1
            }else {
                self.convexHull.array.remove(at: index + 1)
            }
        }
    }
    
    func isLeftTurn(vec1: VectorModel, vec2: VectorModel, vec3: VectorModel)->Bool{
        
        var matrix: [[Float]] = [
            [vec1.x, vec2.x, vec3.x],
            [vec1.z, vec2.z, vec3.z],
            [1.0, 1.0, 1.0]
        ]
        
        var det: Float = 0
        
        det += matrix[0][0]*matrix[1][1]*matrix[2][2]
        det -= matrix[0][0]*matrix[1][2]*matrix[2][1]
        det += matrix[0][1]*matrix[1][2]*matrix[2][0]
        det -= matrix[0][1]*matrix[1][0]*matrix[2][2]
        det += matrix[0][2]*matrix[1][0]*matrix[2][1]
        det -= matrix[0][2]*matrix[1][1]*matrix[2][0]
        
        if(det>0){
            return true
        }else {
            return false
        }
    }
    
    func sortPoints() {
        self.points.array.sort(by: {a, b -> Bool in
            return a.x > b.x
        })
    }
    
    func changeReferencePoint(refelencePoint: NIVectorModel){
        for (index, _) in self.points.array.enumerated(){
            points.array[index].subtract(vec: refelencePoint)
        }
    }
    
    func getPointWithTheSmallestZ() -> NIVectorModel{
        
        var smallestZPoint: NIVectorModel = NIVectorModel(niDiscoveryToken: nil, x: Float.infinity, y: Float.infinity, z: Float.infinity) // a point with the smallest z axis
        var smallestZIndex: Int = 0 // the index of a point with the smallest z axis
        
        // Find a point with the smallest z axis
        for (index, point) in self.points.array.enumerated() {
            if point.z < smallestZPoint.z {
                smallestZPoint = point
                smallestZIndex = index
            }
        }
        
        // Delete the point from array
        self.points.array.remove(at: smallestZIndex)
        
        return smallestZPoint
    }
}
