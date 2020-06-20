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
       if let url = URL(string: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3") {
          let player = AVQueuePlayer()
          let item = AVPlayerItem(url: url)
          looper = AVPlayerLooper(player: player, templateItem: item)
          player.play()
       }
    }
}
