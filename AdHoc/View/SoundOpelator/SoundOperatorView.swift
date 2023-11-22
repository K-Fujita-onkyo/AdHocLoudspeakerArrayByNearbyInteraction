//
//  SoundOpelatorView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import SwiftUI
import MultipeerConnectivity
import simd
struct SoundOperatorView: View {
    
    let screen: CGRect = UIScreen.main.bounds
    let angle = Angle(degrees: -90.0)
    
    let soundImageSize: CGFloat = 30
    let outerRoomSize: CGFloat = 10
    @State private var soundLocation: CGPoint = CGPoint(x: 30, y: 30)
    @State private var soundLocationBasedNI: CGPoint = CGPoint(x: 0, y: 0)
    @State private var innerRoomLocation: CGPoint = CGPoint(x: 0, y: 0)
    @State var soundOpelatorModel: SoundOperatorModel = SoundOperatorModel()
    
    let testConvArray: [simd_float2] = [
                                        simd_float2(3.2, 1.0),
                                        simd_float2(-4.0, 2.0),
                                        simd_float2(-1.0, 9.0),
                                        simd_float2(1.0, 8.0),
                                        simd_float2(4.0, 3.0)]
    
    var body: some View {
        ZStack {
            Color.cyan
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("Sound Operator")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.white)
                VStack{
                    GeometryReader(content: { geometry in
                        
                        Rectangle()
                            .stroke(Color.white, lineWidth: 5.0)
                            .frame(width:screen.width, height: screen.width)
                        
                        ArrowShape()
                            .stroke(Color.red, lineWidth: 5)
                            .position(x: screen.width / 2, y: screen.width)
                        
                        
                        ArrowShape()
                            .stroke(Color.blue, lineWidth: 5)
                            .rotationEffect(self.angle)
                        
                        ZStack {
                            ZStack {
                                //ConvexHullShape(points: self.soundOpelatorModel.convexHullForViewing, outerRoomSize: 10)
                                ConvexHullShape(points: testConvArray, outerRoomSize: Float (self.outerRoomSize))
                                    .fill(Color(red: 0.0, green: 0.78, blue: 0.75))
                                    .stroke(Color.white, lineWidth: 3.0)
                                    
                                    
                                Text("Inner room")
                                    .font(.title2)
                                    .foregroundColor(Color.white)
                            }
                            
                            Circle()
                                .fill(Color(red: 0.0, green: 0.25, blue: 0.5))
                                .frame(width: soundImageSize, height: soundImageSize)
                                .position(soundLocation)
                                .gesture(DragGesture().onChanged({ value in
                                    
                                    if value.location.x < soundImageSize/2 {
                                        self.soundLocation.x = soundImageSize/2
                                    }else if value.location.x > screen.width - soundImageSize/2 {
                                        self.soundLocation.x = screen.width - soundImageSize/2
                                    }else {
                                        self.soundLocation.x = value.location.x
                                    }
                                    
                                    if value.location.y < soundImageSize/2 {
                                        self.soundLocation.y = soundImageSize/2
                                    }else if value.location.y > screen.width - soundImageSize/2 {
                                        self.soundLocation.y = screen.width - soundImageSize/2
                                    }else {
                                        self.soundLocation.y = value.location.y
                                    }
                                   
                                }))
                            
                            Image("SoundMark")
                                .resizable()
                                .frame(width: soundImageSize, height: soundImageSize)
                                .position(soundLocation)
                                .gesture(DragGesture().onChanged({ value in
                                    
                                    if value.location.x < soundImageSize/2 {
                                        self.soundLocation.x = soundImageSize/2
                                    }else if value.location.x > screen.width - soundImageSize/2 {
                                        self.soundLocation.x = screen.width - soundImageSize/2
                                    }else {
                                        self.soundLocation.x = value.location.x
                                    }
                                    
                                    if value.location.y < soundImageSize/2 {
                                        self.soundLocation.y = soundImageSize/2
                                    }else if value.location.y > screen.width - soundImageSize/2 {
                                        self.soundLocation.y = screen.width - soundImageSize/2
                                    }else {
                                        self.soundLocation.y = value.location.y
                                    }
                                    
                                    self.soundLocationBasedNI =  self.calcSoundLocationBasedOnOperatorPoint(point: self.soundLocation)
                                    
                                }))
            
                        
                            
                            ZStack(){
                                Rectangle()
                                    .fill(Color.gray)
                                    .stroke(Color.black, lineWidth: 1.0)
                                    .frame(width: 80, height: 20)
                                    .position(x: screen.width/2, y: screen.width)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 1.0)
                                    .frame(width: 20, height: 7)
                                    .position(x: screen.width/2 + 25, y: screen.width)
                            
                                Text("yours")
                                    .position(x: screen.width/2, y: screen.width)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 10, weight: .black, design: .default))
                            }
                            
                        }
                    })
                    
                } .frame(width: screen.width, height: screen.width)
                Text("")
                    .font(.title2)
                    .foregroundColor(Color.white)
                Text("x: \(soundLocationBasedNI.x)")
                    .font(.title2)
                    .foregroundColor(Color.white)
                Text("z: \(soundLocationBasedNI.y)")
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                HStack{
                    Button("Start Host"){
                              soundOpelatorModel.startHosting()
                          }.buttonStyle(SoundOperatorStartHostButtonStyle())
                    Button("Sop Host"){
                        soundOpelatorModel.stopHosting()
                          }.buttonStyle(SoundOperatorStartHostButtonStyle())
                }
              

            }
        }
        
    }
    func calcSoundLocationBasedOnOperatorPoint(point: CGPoint) -> CGPoint{
        
        let ratioOfLengthPerPixel = self.outerRoomSize / self.screen.width
        let originVector = CGPoint(x: -self.outerRoomSize / 2, y: self.outerRoomSize)
        
        return CGPoint(x: originVector.x +  (point.x * ratioOfLengthPerPixel),
                                    y: originVector.y -  (point.y * ratioOfLengthPerPixel))
    }
}
#Preview {
    SoundOperatorView()
}
