//
//  LoudspeakerView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import SwiftUI
import UIKit
struct LoudspeakerView: View {
    @State private var isPresented: Bool = false
    @ObservedObject var loudspeakerModel: LoudspeakerModel  = LoudspeakerModel()
    var body: some View {
   
        
        ZStack{
            
            if loudspeakerModel.myLocationInfo.isConvexHull {
                Color.green
                    .edgesIgnoringSafeArea(.all)
            }else{
                Color.gray
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack{
                Text("Loudspeaker")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(Color.white)
                
                
                Text(loudspeakerModel.isConvexText)
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                Text(loudspeakerModel.loudspeakerLocationText)
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                HStack{
                    Button("Join"){
                        loudspeakerModel.joinSession()
                    }.buttonStyle(LoudspeakerJoinButtonStyle())
                    Button("Exit"){
                        loudspeakerModel.stopSession()
                    }.buttonStyle(LoudspeakerJoinButtonStyle())
                }
                
//                HStack{
//                    Button("Play"){
//                    }.buttonStyle(LoudspeakerJoinButtonStyle())
//                    Button("Stop"){
//                        loudspeakerModel.stopAudio()
//                    }.buttonStyle(LoudspeakerJoinButtonStyle())
//                }
                
                
            }
        }
    }
}

#Preview {
    LoudspeakerView()
}
