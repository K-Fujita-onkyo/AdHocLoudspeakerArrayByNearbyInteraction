//
//  SoundOpelatorAction.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/10/31.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction

class SoundOperatorModel: NSObject {
    
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
    var associatedPeerIDByNITokenDict: Dictionary<NIDiscoveryToken, MCPeerID> = [:]
    var associatedMessageByNITokenDict: Dictionary<NIDiscoveryToken, MessageModel> = [:]
    @Published var convexHullForViewing: [simd_float2] = []
    @Published var pointsForViewing: [simd_float2] = []
    
    //MARK: - Audio sharing valiables
    
    override init() {
        super.init()
//        self.setupAudioSharing()
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
    
    func startHosting() {
        // Initialize MCNearbyServiceAdvertiser and the delegate declaration
        self.mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: nil, serviceType: mcServiceType)
        self.mcNearbyServiceAdvertiser.delegate = self
        self.mcNearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func stopHosting() {
        self.mcNearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    func convertMessageToData(message: MessageModel) -> Data! {
        let encoder: JSONEncoder = JSONEncoder()
        var data: Data!
        
        do{
            data = try encoder.encode(message)
            print("can encode!!")
        } catch{
            print("not")
        }
        
        return data
        
    }
    
    func sendData(data: Data, mcPeerID: MCPeerID){
        do{
            try self.mcSession.send( data,
                                            toPeers: [mcPeerID],
                                            with: .reliable)
            }catch let error as NSError {
                        print(error.localizedDescription)
            }
    }
    
    // MARK: - Function for Calculation of a Inner Room
    
    // Reset
    func resetConvexBoolsOfAllMessages(){
        for (key, _) in self.associatedMessageByNITokenDict {
            self.associatedMessageByNITokenDict[key]?.isConvexHull = false
        }
    }
    
    // Update
    func updateInnerRoom(updatedNearbyObjects: [NINearbyObject]){
        
        let innerRoom: ConvexHullModel = ConvexHullModel()
        

        for updatedNearbyObject in updatedNearbyObjects {
            
            let distance: Float! = updatedNearbyObject.distance
            let direction: simd_float3! = updatedNearbyObject.direction
            
            if  distance == nil || direction == nil {
                    print("YES！！！！")
                return
            }
            
            // Initialize a message of a loudspeaker.
            // TODO: - about "Location: * 10" ::: if we will try to test in real hardware, please delete the calculation
            let message: MessageModel = MessageModel(
                isConvexHull: false,
                l_x: Float(direction.x.description)! * Float(distance.description)!*10,
                l_y: Float(direction.y.description)! * Float(distance.description)!*10,
                l_z: Float(direction.z.description)! * Float(distance.description)!*10,
                s_x: 0,
                s_y: 0,
                s_z: 0,
                soundFloatBuffer: []
            )
            
            // Update the message
            self.associatedMessageByNITokenDict.updateValue(message, forKey: updatedNearbyObject.discoveryToken)
        }
        
        // Initialize
        self.resetConvexBoolsOfAllMessages()
        self.pointsForViewing = []
        self.convexHullForViewing = []
        
        // Insert loudspeaker locations to ConvexHullModel(3D) and pointForViewing(2D)
        for messageDict in self.associatedMessageByNITokenDict {
            // TODO: - about "appendPoint" ::: I set the location for a simulation in Mac PC. Please change those followings.
            innerRoom.appendPoint(
                niDiscoveryToken: messageDict.key,
                x: messageDict.value.loudspeakerLocation.x,
                y: messageDict.value.loudspeakerLocation.z, // Please change z to y in a hardware demo
                z: messageDict.value.loudspeakerLocation.y // Please change y to z in a hardware demo
            )
            
            // TODO: - about "appendPoint" ::: I set the location for a simulation in Mac PC. Please change those followings.
            self.pointsForViewing.append(
                simd_float2(
                    messageDict.value.loudspeakerLocation.x,
                    messageDict.value.loudspeakerLocation.y // Please change y to z in a hardware demo
                )
            )
        }
        
        // Calculate the convex hull
        innerRoom.calcConvexHull()
        
        for loudspeaker in innerRoom.niConvexHull.array {
            
            self.associatedMessageByNITokenDict[loudspeaker.niDiscoveryToken]?.isConvexHull = true
            
            // For View
            self.convexHullForViewing.append(
                simd_float2(
                    loudspeaker.vector.x,
                    loudspeaker.vector.z
                )
            )
        }
    }
    
    //MARK: - Function For Audio Sharing
    
}

// MARK: - NISessionDelegate
extension SoundOperatorModel: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        
        print("owakon")
        self.updateInnerRoom(updatedNearbyObjects: nearbyObjects)
        
        for assosiatedPeerIDByNIToken in self.associatedPeerIDByNITokenDict {
            let niToken = assosiatedPeerIDByNIToken.key
            let mcPeerID = assosiatedPeerIDByNIToken.value
            let message = self.associatedMessageByNITokenDict[niToken]!
           message.soundFloatBuffer = []
            
            let encoder: JSONEncoder = JSONEncoder()
            var data: Data!
            
            do{
                data = try encoder.encode(message)
                print("can encode!!")
            } catch{
                print("not")
            }
            
            do{
                try self.mcSession.send( data,
                                                toPeers: [mcPeerID],
                                                with: .reliable)
                }catch let error as NSError {
                            print(error.localizedDescription)
                }
        }
        
    }
}

// MARK: - MCSessionDelegate
extension SoundOperatorModel: MCSessionDelegate{
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
        self.associatedPeerIDByNITokenDict.updateValue(peerID, forKey: peerDiscoverToken)
        let config = NINearbyPeerConfiguration(peerToken: peerDiscoverToken)
        self.niSession?.run(config)
        print("getSession was run") 
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

// MARK: - MCNearbyServiceAdvertiser
extension SoundOperatorModel: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.connectedTest = "connected!!"
        invitationHandler(true, self.mcSession)
    }
}

// MARK: - ConvexFull Calculation
extension SoundOperatorModel {
}
