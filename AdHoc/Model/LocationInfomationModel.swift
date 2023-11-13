//
//  LocationInfomationModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation
import NearbyInteraction

class LocationInfomationModel: NSObject {
    
    var isConvexHull: Bool
    var loudspeakerLocation: simd_float3
    var soundLocation: simd_float3

    init(isConvexHull: Bool, l_x: Float, l_y: Float, l_z: Float, s_x: Float, s_y: Float, s_z: Float) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = simd_float3(l_x, l_y, l_z)
        self.soundLocation = simd_float3(s_x, s_y, s_z)
        
    }
    init(isConvexHull: Bool, loudspeakerLocation: simd_float3, soundLocation: simd_float3) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = loudspeakerLocation
        self.soundLocation = soundLocation
    }
    
    func toData() -> Data {
        var strData = ""
        strData.append(String(isConvexHull) + "/")
        strData.append(String(loudspeakerLocation.x) + ","
                                    + String(loudspeakerLocation.y) + ","
                                    + String(loudspeakerLocation.z) + "/")
        strData.append(String(soundLocation.x) + ","
                                    + String(soundLocation.y) + ","
                                    + String(soundLocation.z) + "/")
        let data: Data = strData.data(using: String.Encoding.utf8)!
        return data
    }
    
    func fromData(data: Data!) {
        
        guard let strDataArray: [String] =  String(data: data, encoding: .utf8)?.components(separatedBy: "/")
        else {
            print("Failed to decode data.")
            return
        }
        
        self.isConvexHull = isConvexHullByStr(bool: strDataArray[0])
        
        let strLLocation: [String] = strDataArray[1].components(separatedBy: ",")
        
        self.loudspeakerLocation = simd_float3(Float(strLLocation[0]) ?? 0, Float(strLLocation[1]) ?? 0, Float(strLLocation[2]) ?? 0)
        print(strLLocation)
        let strSLocation: [String] = strDataArray[2].components(separatedBy: ",")
        self.soundLocation = simd_float3(Float(strSLocation[0]) ?? 0, Float(strSLocation[1]) ?? 0, Float(strSLocation[2]) ?? 0)
        
    }
    
    func isConvexHullByStr(bool: String) -> Bool {
        return (bool == "true")
    }
    
    func getIsConvexHullText() -> String {
        return "\(self.isConvexHull)"
    }
    
    func getLoudspeakerLocationText() -> String {
        print("\(self.loudspeakerLocation.x), \(self.loudspeakerLocation.y), \(self.loudspeakerLocation.z)")
        return "(\(String(format: "%.3f", self.loudspeakerLocation.x)) , \(String(format: "%.3f", self.loudspeakerLocation.y)), \(String(format: "%.3f",self.loudspeakerLocation.z)))"
    }
}
