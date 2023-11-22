//
//  SoundOpelatorStartHostButtonStyle.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/13.
//

import Foundation
import SwiftUI

struct SoundOperatorStartHostButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.white : Color.orange)
            .cornerRadius(12.0)
        }
}
