//
//  AudioTestModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/16.
//

import Foundation
import AVFoundation

class AudioTestModel: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer!
    // エンジンの生成
    let audioEngine = AVAudioEngine()
    // ソースノードの生成
    let player1 = AVAudioPlayerNode()
    func audioPlay(){
        //ファイルパスの取得
        guard let path = Bundle.main.path(forResource: "Drums", ofType: "wav") else {
            print("file not found")
            return
        }
                
        //音声ファイルの読み込みと再生
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.delegate = self
            player.play()
            print("Sound")
        }catch{
            print("Playback failed")
        }
    }
    
    func playSineWave() {
      // プレイヤーノードからオーディオフォーマットを取得
        let audioFormat = player1.outputFormat(forBus: 0)
      // サンプリング周波数: 44.1K Hz
      let sampleRate = Float(audioFormat.sampleRate)
      // 3秒間鳴らすフレームの長さ
      let length = 3.0 * sampleRate
      // PCMバッファーを生成
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity:UInt32(length))
      // frameLength を設定することで mDataByteSize が更新される
        buffer!.frameLength = UInt32(length)
      // オーディオのチャンネル数
      let channels = Int(audioFormat.channelCount)
      for ch in (0..<channels) {
          let samples = buffer?.floatChannelData![ch]
          for n in 0..<Int(buffer!.frameLength) {
              samples![n] = sinf(Float(2.0  * Double.pi) * 440.0 * Float(n) / sampleRate)
        }
      }
          
      // オーディオエンジンにプレイヤーをアタッチ
        audioEngine.attach(player1)
      let mixer = audioEngine.mainMixerNode
      // プレイヤーノードとミキサーノードを接続
      audioEngine.connect(player1, to: mixer, format: audioFormat)
      // 再生の開始を設定
        player1.scheduleBuffer(buffer!) {
          print("Play completed")
      }
        
      do {
        // エンジンを開始
        try audioEngine.start()
        // 再生
        player1.play()
      } catch let error {
        print(error)
      }
    }
}
