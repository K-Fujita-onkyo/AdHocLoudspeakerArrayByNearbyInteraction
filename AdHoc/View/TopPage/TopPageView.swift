//
//  ContentView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import SwiftUI

struct TopPageView: View {
    
    @State private var path = NavigationPath()
    @State private var path1 = NavigationPath()
    @State var soundOpelatorPage: Int? = 0
    @State var loudspeakerPage: Int? = 0
    @State private var showLoudspeakerView: Bool = false
    @State private var showSoundOpelatorView: Bool = false
    @State private var showConvexHullTestView: Bool = false
    
    private  var positionList: [Position] = [
        Position(id: 0, name: "Loudspeaker", imageName: "LoudspeakerMark"),
        Position(id: 1, name: "Sound operator", imageName: "SoundOperatorMark"),
        Position(id: 2, name: "Convex Hull Test", imageName: "Sample")
    ]
    
    var body: some View {
        
        ZStack {
            
            // Setting a background
            Color.red
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                
                // Logo
                Image("akabeko")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 50)
                
                // Title
                VStack (){
                    Text("AdHocLoudspeakerArray")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundColor(Color.white)
                    Text("You can play spatial sound anywhere\n")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
                
                // Button styles
                VStack{
                    
                    Text("Please select your position.")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    
                    Button(action: {
                        self.showLoudspeakerView.toggle()
                    }) {
                        PositionView(position: positionList[0])
                    }.sheet(isPresented: self.$showLoudspeakerView) {
                        LoudspeakerView()
                    }.buttonStyle(RoundedCornersButtonStyle())
                    
                    Button(action: {
                        self.showSoundOpelatorView.toggle()
                    }) {
                        PositionView(position: positionList[1])
                    }.sheet(isPresented: self.$showSoundOpelatorView) {
                        SoundOperatorView()
                    }.buttonStyle(RoundedCornersButtonStyle())
                    
                    // ConvexHullTest
                    Button(action: {
                        self.showConvexHullTestView.toggle()
                    }) {
                        PositionView(position: positionList[2])
                    }.sheet(isPresented: self.$showConvexHullTestView) {
                        TestView()
                    }.buttonStyle(RoundedCornersButtonStyle())
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    TopPageView()
}
