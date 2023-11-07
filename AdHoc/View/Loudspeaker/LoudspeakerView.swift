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
    @State var text: String = ""
    @State var locationInfo: String = ""
    @ObservedObject var loudspeakerModel: LoudspeakerModel  = LoudspeakerModel()
    var body: some View {
        NavigationView{
            VStack{
                Text("LoudspeakerView")
                Text(text)
                Text(locationInfo)
                Text(loudspeakerModel.getMessageTest)
                
                Button("join"){
                    loudspeakerModel.joinSession()
                }
                
                Button("change"){
                    text = loudspeakerModel.connectedTest
                    locationInfo = loudspeakerModel.getMessageTest
                }
            }
            
        }
    }
}

#Preview {
    LoudspeakerView()
}
