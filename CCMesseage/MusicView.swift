//
//  MusicView.swift
//  CCMesseage
//
//  Created by 張睿玹 on 2020/6/20.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import WebKit
class MusicView: UIViewController {
    @IBOutlet weak var WK: WKWebView!
    @IBOutlet weak var inputYTID: UITextField!
    @IBAction func clickLoad(_ sender: Any) {
        let url = URL(string: "https://www.youtube.com/embed/\(inputYTID.text ?? YTID)?autoplay=1&playisinline=1")!
        WK.load(URLRequest(url: url))
    }
    var YTID : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if YTID == ""{
            YTID="A4v438pYbm8"
        }
        guard let YTID = YTID else {
            return
        }
        inputYTID.text = YTID
        
        let url = URL(string: "https://www.youtube.com/embed/\(YTID)?autoplay=1&playisinline=1")!
        WK.load(URLRequest(url: url))
    }
}
