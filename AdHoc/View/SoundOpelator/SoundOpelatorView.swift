//
//  SoundOpelatorView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import SwiftUI
import MultipeerConnectivity

struct SoundOpelatorView: View {
    
    @State var soundOpelatorModel: SoundOpelatorModel = SoundOpelatorModel()
    
    var body: some View {
        Text("SoundOpelatorView OK")
        Text(soundOpelatorModel.connectedTest)
        Button(action: {
            soundOpelatorModel.startHosting()
        }){
            Text("host")
        }
        Button(action: {
            print(soundOpelatorModel.associatedID)
        }){
            Text("send")
        }
    }
    
}
#Preview {
    SoundOpelatorView()
}
