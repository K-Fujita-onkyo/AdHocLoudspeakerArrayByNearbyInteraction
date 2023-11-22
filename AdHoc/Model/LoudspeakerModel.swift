
//  LoudspeakerAction.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/01.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction
import SwiftUI

class LoudspeakerModel: NSObject, ObservableObject{
    
    // MARK: - Test valiables
    var myLocationInfo: MessageModel = MessageModel(isConvexHull: false, l_x: 0, l_y: 0, l_z: 0, s_x: 0, s_y: 0, s_z: 0, soundFloatBuffer: [])
    @Published var isConvexText: String = "-"
    @Published var loudspeakerLocationText: String = "-"    
    //MARK: - NearbyIntreaction valiables
    var niSession: NISession!
    var sharedTokenWithPeer: Bool!
    var tokenData: Data!
    
    //MARK: - Multipeer Connectivity constants and valiables
    let mcServiceType: String = "ad-hoc-uwb"
    var mcSession: MCSession!
    var mcNearbyServiceBrowser : MCNearbyServiceBrowser!
    var mcBrowserViewController: MCBrowserViewController!
    var mcPeerID: MCPeerID!
    
    //MARK: - Audio sharing valiables
//    var audioFormat: AVAudioFormat!
//    var audioEngine: AVAudioEngine = AVAudioEngine()
//    var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioFloatArray: [Float] = []
//    
    
    
    
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
        self.mcSession = MCSession(peer: self.mcPeerID)
        self.mcSession.delegate = self
    }
    
    func joinSession() {
        self.mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: self.mcPeerID, serviceType: self.mcServiceType)
        self.mcNearbyServiceBrowser.delegate = self
        self.mcNearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopSession() {
//         self.mcNearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: - Function For Sound Sharing
}

// MARK: - NISessionDelegate
extension LoudspeakerModel: NISessionDelegate {
    
}


// MARK: - MCSessionDelegate
extension LoudspeakerModel: MCSessionDelegate{
    // for sending data
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
                   case .connected:
                       print( "\(peerID.displayName)が接続されました")
                  
                       do {
                           try session.send(self.tokenData,
                                                       toPeers: session.connectedPeers,
                                                       with: MCSessionSendDataMode.reliable
                                                       )
                       } catch {
                                   print(error.localizedDescription)
                       }
                   case .connecting:
                       print("\(peerID.displayName)が接続中です")
                   case .notConnected:
                       print("\(peerID.displayName)が切断されました")
                      @unknown default:
                       print("\(peerID.displayName)が想定外の状態です")
                      }
    }
    
    // for getting data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let decorder: JSONDecoder = JSONDecoder()
        DispatchQueue.main.async{
            do{
                self.myLocationInfo = try decorder.decode(MessageModel.self, from: data)
                print("can decode!!")
            }catch {
                print("OUT")
            }
        }

            self.isConvexText = self.myLocationInfo.getIsConvexHullText()
            self.loudspeakerLocationText = "Loudspeaker's location: (x, y, z)  \n = " + self.myLocationInfo.getLoudspeakerLocationText()
        
           print("OK")
        
        
        guard let peerDiscoverToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data)
        else {
            print("Failed to decode data.")
            return
        }
        
        print("NISessionn OK")
        let config = NINearbyPeerConfiguration(peerToken: peerDiscoverToken)
        self.niSession?.run(config)
        print("LustOK")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension LoudspeakerModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found: \(peerID)")
        browser.invitePeer(peerID, to: self.mcSession, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
}

extension LoudspeakerModel:  MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    }
}
