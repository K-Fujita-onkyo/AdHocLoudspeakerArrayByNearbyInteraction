//
//  PositionView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import Foundation
import SwiftUI

struct PositionView: View {
    var position: Position
    
    var body: some View {
        
        HStack{
                
                // Mark
                position.image
                    .resizable()
                    .frame(width: 50, height: 50)
                
                // Name
                Text(position.name)
                
                // Create Space
                //Spacer()
            }
    }
    
    init(){
        self.position = Position()
    }
    
    init(position: Position) {
        self.position = position
    }
    
}

#Preview {
    PositionView()
}


