//
//  LoudspeakerJoinButtonStyle.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/11.
//

import Foundation
import SwiftUI

struct LoudspeakerJoinButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.white : Color.orange)
            .cornerRadius(12.0)
        }
}
