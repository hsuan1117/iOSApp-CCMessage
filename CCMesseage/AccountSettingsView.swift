//
//  AccountSettingsView.swift
//  CCMesseage
//
//  Created by student on 2020/6/19.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import SwifterSwift
class AccountSettingsView: UIViewController {
    
    @IBOutlet weak var AccountID: UILabel!
    @IBOutlet weak var AccountName: UITextField!
    
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

        ACM.onAuthInit(completion: {
            AuthResult in
            self.AccountID.text = "Your ID : \(AuthResult.user?.uid ?? "")"
        })
    }
}
