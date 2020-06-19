//
//  AccountSettingsView.swift
//  CCMesseage
//
//  Created by student on 2020/6/19.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import SwifterSwift
import FirebaseFirestore
import FirebaseAuth
class AccountSettingsView: UIViewController {
    
    @IBOutlet weak var AccountID: UILabel!
    @IBOutlet weak var AccountName: UITextField!
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    let ACM = AccountManager();
    
    @IBAction func OnSaveClick(_ sender: Any) {
        if AccountName.text == nil{
            showAlert(title: "警告", message: "輸入名稱")
            return;
        }
        ACM.setName(account: AccountName.text!, completion: {
            self.showAlert(title: "狀態", message: "完成")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Loading.startAnimating()
        ACM.onAuthInit(completion: {
            AuthResult in
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument(completion: {
                (snapshot,error) in
                self.AccountName.text = snapshot?["name"] as? String ?? ""
                self.Loading.stopAnimating()
            })
            self.AccountID.text = "Your ID : \(AuthResult.user?.uid ?? "")"
        })
    }
}
