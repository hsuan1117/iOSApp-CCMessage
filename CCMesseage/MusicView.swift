//
//  MusicView.swift
//  CCMesseage
//
//  Created by 張睿玹 on 2020/6/20.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import AVFoundation
class MusicView: UIViewController {
    var looper: AVPlayerLooper?
    override func viewDidLoad() {
       super.viewDidLoad()
       if let url = URL(string: "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview118/v4/69/0e/98/690e98db-440d-cb0c-2bff-91b00a05bdda/mzaf_1674062311671795807.plus.aac.p.m4a") {
          let player = AVQueuePlayer()
          let item = AVPlayerItem(url: url)
          looper = AVPlayerLooper(player: player, templateItem: item)
          player.play()
       }
    }
}
