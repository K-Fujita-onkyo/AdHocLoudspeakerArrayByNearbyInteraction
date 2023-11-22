//
//  LocationInfomationModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation
import NearbyInteraction

class MessageModel: NSObject, Codable {
    
    var isConvexHull: Bool
    var loudspeakerLocation: simd_float3
    var soundLocation: simd_float3
    var soundFloatBuffer: [Float]

    override init(){
        self.isConvexHull = false
        self.loudspeakerLocation = simd_float3(0, 0, 0)
        self.soundLocation = simd_float3(0, 0, 0)
        self.soundFloatBuffer = []
    }
    init(isConvexHull: Bool, l_x: Float, l_y: Float, l_z: Float, s_x: Float, s_y: Float, s_z: Float, soundFloatBuffer: [Float]) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = simd_float3(l_x, l_y, l_z)
        self.soundLocation = simd_float3(s_x, s_y, s_z)
        self.soundFloatBuffer = soundFloatBuffer
    }
    
    init(isConvexHull: Bool, loudspeakerLocation: simd_float3, soundLocation: simd_float3, soundFloatBuffer: [Float]) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = loudspeakerLocation
        self.soundLocation = soundLocation
        self.soundFloatBuffer = soundFloatBuffer
    }
    
    func getAudioBuffer(audioBuffer: [Float]){
        self.soundFloatBuffer = audioBuffer
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
