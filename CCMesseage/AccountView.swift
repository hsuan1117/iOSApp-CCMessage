//
//  AccountView.swift
//  CCMesseage
//
//  Created by student on 2020/4/17.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwifterSwift

class AccountView: UIViewController {
    let fAccount = Account()
    
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputAccount: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    @IBAction func OnclickRegister(_ sender: Any) {
        if inputAccount.isEmpty {
            showAlert(title: "警告", message: "帳號為空")
        }else if inputPassword.isEmpty {
            showAlert(title: "警告", message: "密碼為空")
        }else{
            fAccount.registerWithPassword(account: inputPassword.text!, password: inputAccount.text!)
        }
    }
    @IBAction func OnclickLogin(_ sender: Any) {
       
        if inputAccount.isEmpty {
            showAlert(title: "警告", message: "帳號為空")
        }else if inputPassword.isEmpty {
            showAlert(title: "警告", message: "密碼為空")
        }else{
            fAccount.loginWithPassword(account: inputPassword.text!, password: inputAccount.text!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let pLayer = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        pLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.view.addSubview(pLayer)
        //self.view.bringSubviewToFront(pLayer)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let alert = UIAlertController(title: "警告", message: "你尚未登入", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    (UIAlertAction) in
                    pLayer.isHidden = true
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
               //已登入
                
                
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
