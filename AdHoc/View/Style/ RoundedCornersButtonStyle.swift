//
//   RoundedCornersButtonStyle.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import Foundation
import SwiftUI

struct RoundedCornersButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.red : Color.orange)
            .cornerRadius(12.0)
        }
}
