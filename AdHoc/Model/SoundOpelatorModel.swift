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
    
    //MARK: - associated by a NI tokenvaliables
    var associatedPeerIDByNIToken: Dictionary<NIDiscoveryToken, MCPeerID> = [:]
    var associatedLocationInfoByNIToken: Dictionary<NIDiscoveryToken, LocationInfomationModel> = [:]
    
    
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
        
        var innerRoom: ConvexHullModel = ConvexHullModel()
        // MARK: - Loudspeaker
        var locationInfo: LocationInfomationModel = LocationInfomationModel(isConvexHull: false, l_x: 0, l_y: 0, l_z: 0, s_x: 0, s_y: 0, s_z: 0)
        
        for nearbyObject in nearbyObjects {
            
        // TODO: - If the first diarection of a loudspeakers is nil, the system need to skip the calculation for convex hull.
            /// Need to skip action
            ///
            ///
        
            locationInfo.isConvexHull = false
            if let distance = nearbyObject.distance {
                if let diarection = nearbyObject.direction {
                    locationInfo.loudspeakerLocation.x = Float(diarection.x.description)! * Float(distance.description)!
                    locationInfo.loudspeakerLocation.y = Float(diarection.y.description)! * Float(distance.description)!
                    locationInfo.loudspeakerLocation.z = Float(diarection.z.description)! * Float(distance.description)!
                    self.associatedLocationInfoByNIToken.updateValue(locationInfo, forKey: nearbyObject.discoveryToken)
                }else {
                    print("Error: has no direction")
                    return
                }
            } else {
                print("Error: has no distance")
                return
            }
        }
        
        print("IDsize: " + String(self.associatedPeerIDByNIToken.count))
        
        for location in self.associatedLocationInfoByNIToken {
            print(location)
            innerRoom.appendPoint(niDiscoveryToken: location.key,
                                                        x: location.value.loudspeakerLocation.x * 100,
                                                        y:  location.value.loudspeakerLocation.z * 100,
                                                        z:  location.value.loudspeakerLocation.y * 100)
        }
        
        print("ConvPointsize: " + String(innerRoom.niPoints.size))
        innerRoom.calcConvexHull()
        print("Convsize: " + String(innerRoom.niConvexHull.size))
        
        
        for loudspeaker in innerRoom.niConvexHull.array {
            self.associatedLocationInfoByNIToken[loudspeaker.niDiscoveryToken]?.isConvexHull = true
        }
        
        //sendLocationData(locationData: self.locationInfo)
        for nearbyObject in nearbyObjects {
            if self.associatedPeerIDByNIToken.keys.contains(nearbyObject.discoveryToken){
                do{
                    try self.mcSession.send( self.associatedLocationInfoByNIToken[nearbyObject.discoveryToken]!.toData(), // TODO: - If the data is nil, the system must not send the data.
                                                toPeers: [self.associatedPeerIDByNIToken[nearbyObject.discoveryToken]!],
                                                with: .reliable)
                    }catch let error as NSError {
                        print(error.localizedDescription)
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
        self.associatedPeerIDByNIToken.updateValue(peerID, forKey: peerDiscoverToken)
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
extension SoundOpelatorModel: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.connectedTest = "connected!!"
        invitationHandler(true, self.mcSession)
    }
}

// MARK: - ConvexFull Calculation
extension SoundOpelatorModel {
}
