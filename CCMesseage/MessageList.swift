//
//  MessageList.swift
//  CCMesseage
//
//  Created by student on 2020/3/27.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import Firebase

class MessageList: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pLayer = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        pLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.view.addSubview(pLayer)
        //self.view.bringSubviewToFront(pLayer)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                let alert = UIAlertController(title: "警告", message: "你尚未登入", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    (UIAlertAction) in
                    pLayer.isHidden = true
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                
            }
        }
    }
    
}
