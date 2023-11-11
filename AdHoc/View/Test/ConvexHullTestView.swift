//
//  ConvexTestView.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/09.
//

import SwiftUI

struct ConvexHullTestView: View {
    var convexHull: ConvexHullTestModel = ConvexHullTestModel()
    var body: some View {
        Button(action: {
            //convexHull.test()
            convexHull.test2()
        }){
            Text("ConvTest")
        }
    }
}

#Preview {
    ConvexHullTestView()
}
