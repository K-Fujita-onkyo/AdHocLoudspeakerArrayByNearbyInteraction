//
//  SoundOpelatorAction.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction

class SoundOpelatorModel: NSObject {
    
    // MARK: - Loudspeaker
    var locationInfo: LocationInfomationModel = LocationInfomationModel(isConvexHull: false, l_x: 0, l_y: 0, l_z: 0, s_x: 0, s_y: 0, s_z: 0)
    
    // MARK: - Test valiables
    var connectedTest: String = "not connected"
    
    //MARK: - NearbyIntreaction valiables
    var niSession: NISession!
    var sharedTokenWithPeer: Bool!
    var tokenData: Data!
    
    //MARK: - Multipeer Connectivity constants and valiables
    let mcServiceType: String = "ad-hoc-uwb"
    var mcSession: MCSession!
    var mcNearbyServiceBrowser : MCNearbyServiceBrowser!
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    var mcPeerID: MCPeerID!
    
    //MARK: - associated ID valiables
    var associatedID: Dictionary<NIDiscoveryToken, MCPeerID> = [:]
    
    
    override init() {
        super.init()
        self.setupNearbyInteraction()
        self.setupMultipeerConnectivity()
    }
    
    // MARK: - Function For Nearby Interaction
    func setupNearbyInteraction(){
        // Create a new session for each peer
        self.niSession = NISession()
        self.niSession.delegate = self
        self.sharedTokenWithPeer = false
        
        guard let token = self.niSession?.discoveryToken else {
            return
        }
        
        self.tokenData = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
        
    }
    
    // MARK: - Function For Multipeer Connectivity
    func setupMultipeerConnectivity(){
        self.mcPeerID = MCPeerID(displayName: UIDevice.current.name)
        self.mcSession = MCSession(peer: mcPeerID)
        self.mcSession.delegate = self
    }
    
    func sendLocationData(locationData: LocationInfomationModel){
        if self.mcSession.connectedPeers.count > 0 {
            
            do{
                try self.mcSession.send(locationData.toData(),
                                        toPeers: self.mcSession.connectedPeers,
                                       with: .reliable
                                      )
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func startHosting() {
        // Initialize MCNearbyServiceAdvertiser and the delegate declaration
        self.mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: nil, serviceType: mcServiceType)
        self.mcNearbyServiceAdvertiser.delegate = self
        self.mcNearbyServiceAdvertiser.startAdvertisingPeer()
        print("host")
    }
    
}

// MARK: - NISessionDelegate
extension SoundOpelatorModel: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        for nearbyObject in nearbyObjects {
            if let distance = nearbyObject.distance {
                if let diarection = nearbyObject.direction {
                    self.locationInfo.loudspeakerLocation.x = Float(diarection.x.description)! * Float(distance.description)!
                    self.locationInfo.loudspeakerLocation.y = Float(diarection.y.description)! * Float(distance.description)!
                    self.locationInfo.loudspeakerLocation.z = Float(diarection.z.description)! * Float(distance.description)!
                    //sendLocationData(locationData: self.locationInfo)
                    if self.associatedID.keys.contains(nearbyObject.discoveryToken) {
                        do{
                            try self.mcSession.send(locationInfo.toData(),
                                                    toPeers: [self.associatedID[nearbyObject.discoveryToken]!],
                                                   with: .reliable
                                                  )
                            print("send to \(nearbyObject.discoveryToken) + \(String(describing: self.associatedID[nearbyObject.discoveryToken]))")
                        }catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - MCSessionDelegate
extension SoundOpelatorModel: MCSessionDelegate{
    // for sending data
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected:
                self.connectedTest = "\(peerID.displayName)が接続されました"
                do {
                    try session.send(self.tokenData,
                                                toPeers: session.connectedPeers,
                                                with: MCSessionSendDataMode.reliable
                                                )
                    } catch {
                            print(error.localizedDescription)
                    }
            case .connecting:
                self.connectedTest = "\(peerID.displayName)が接続中です"
            case .notConnected:
                self.connectedTest = "\(peerID.displayName)が切断されました"
               @unknown default:
                self.connectedTest = "\(peerID.displayName)が想定外の状態です"
               }
        
    }
    
    // for getting data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard let peerDiscoverToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data)
        else {
            print("Failed to decode data.")
            return
        }
        self.associatedID.updateValue(peerID, forKey: peerDiscoverToken)
        let config = NINearbyPeerConfiguration(peerToken: peerDiscoverToken)
        self.niSession?.run(config)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

// MARK: - MCNearbyServiceAdvertiser
extension SoundOpelatorModel:   MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            print("InvitationFrom: \(peerID)")
        self.connectedTest = "connected!!"
        invitationHandler(true, self.mcSession)
    }
}
