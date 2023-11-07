//
//  AssociatedIDModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/06.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction

class AssociatedIDModel: NSObject {
    
    var niDiscoveryToken: NIDiscoveryToken!
    var mcPeerID: MCPeerID!
    
    init(niDiscoveryToken: NIDiscoveryToken!, mcPeerID: MCPeerID!) {
        self.niDiscoveryToken = niDiscoveryToken
        self.mcPeerID = mcPeerID
    }
}
