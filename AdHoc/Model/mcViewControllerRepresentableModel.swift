//
//  ViewControllerRepresentableModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//


import UIKit
import SwiftUI
import MultipeerConnectivity

struct mcViewControllerRepresentableModel: UIViewControllerRepresentable {
    typealias UIViewControllerType =  UIViewController
    var mcBrowserViewController: MCBrowserViewController
    init(mcBrowserViewController: MCBrowserViewController){
        self.mcBrowserViewController = mcBrowserViewController
    }
    
    func makeUIViewController(context: Context) ->  UIViewController {
        return self.mcBrowserViewController
    }
        
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
