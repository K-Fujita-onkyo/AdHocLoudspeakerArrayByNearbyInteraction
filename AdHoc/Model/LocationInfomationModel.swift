//
//  LocationInfomationModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation
class LocationInfomationModel: NSObject {
    
    var isConvexHull: Bool
    var loudspeakerLocation: VectorModel
    var soundLocation: VectorModel

    init(isConvexHull: Bool, l_x: Float, l_y: Float, l_z: Float, s_x: Float, s_y: Float, s_z: Float) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = VectorModel(x: l_x, y: l_y, z: l_z)
        self.soundLocation = VectorModel(x: s_x, y: s_y, z: s_z)
        
    }
    init(isConvexHull: Bool, loudspeakerLocation: VectorModel, soundLocation: VectorModel) {
        self.isConvexHull = isConvexHull
        self.loudspeakerLocation = loudspeakerLocation
        self.soundLocation = soundLocation
    }
    
    func fromData(data: Data) -> String{
        return String.init(data: data, encoding: .utf8)!
        
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
}

