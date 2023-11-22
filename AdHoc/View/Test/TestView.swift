//
//  ConvexTestView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/09.
//

import SwiftUI
import AVFoundation

struct TestView: View {
    var convexHull: ConvexHullTestModel = ConvexHullTestModel()
    var audioTest: AudioTestModel = AudioTestModel()
    var body: some View {
        Button(action: {
            //convexHull.test()
            convexHull.test2()
        }){
            Text("Convex Test")
        }.buttonStyle(RoundedCornersButtonStyle())
        
        Button(action: {
            //convexHull.test()
            self.audioTest.playSineWave()
        }){
            Text("Sound Test")
        }.buttonStyle(RoundedCornersButtonStyle())
        
    }
    

}

#Preview {
    TestView()
}
