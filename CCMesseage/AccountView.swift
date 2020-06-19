import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwifterSwift

class AccountView: UIViewController {
    var ACM = AccountManager()
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputAccount: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    @IBAction func OnclickRegister(_ sender: Any) {
        if inputAccount.isEmpty {
            showAlert(title: "警告", message: "帳號為空")
        }else if inputPassword.isEmpty {
            showAlert(title: "警告", message: "密碼為空")
        }else{
            ACM.registerWithPassword(account: inputAccount.text!, password: inputPassword.text! ,
                                     login: true, onRegister:{
                result in
                self.showAlert(title: "Succeed", message: "Register Succeed")
                if result.error != nil{
                    self.showAlert(title: "Error", message: result.error.debugDescription)
                }
                if result.auth != nil {
                    self.showAlert(title: "Succeed", message: "Register Succeed")
                }
            },onLogin: {
                result in
                
            })
        }
    }
    @IBAction func OnclickLogin(_ sender: Any) {
        if inputAccount.isEmpty {
            showAlert(title: "警告", message: "帳號為空")
        }else if inputPassword.isEmpty {
            showAlert(title: "警告", message: "密碼為空")
        }else{
            ACM.loginWithPassword(account: inputAccount.text!, password: inputPassword.text!, completion: {
                result in
                if result.error != nil{
                    self.showAlert(title: "Error", message: result.error?.localizedDescription)
                }
                if result.auth != nil {
                    self.showAlert(title: "Succeed", message: "Login Succeed")
                }
            })
        }
    }
    @IBAction func OnLogoutClick(_ sender: Any) {
        ACM.logout(completion:{
            self.showAlert(title: "提示", message: "登出成功")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loading.startAnimating()
        ACM.onAuthInit(completion: {
            result in
            if result.user == nil {
                self.btnLogin.isHidden = false
                self.btnRegister.isHidden = false
                self.inputAccount.isHidden = false
                self.inputPassword.isHidden = false
                self.btnLogout.isHidden = true
                self.btnSettings.isHidden = true
                self.labelStatus.isHidden = true
                self.Loading.stopAnimating()
            } else {
               //已登入
                self.btnLogin.isHidden = true
                self.btnRegister.isHidden = true
                self.inputAccount.isHidden = true
                self.inputPassword.isHidden = true
                self.btnLogout.isHidden = false
                self.btnSettings.isHidden = false
                self.labelStatus.isHidden = false
                let db = Firestore.firestore()
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument(completion: {
                    (snapshot,error) in
                    self.labelStatus.text = "Hey, \(snapshot?["name"] as? String ?? "")"
                    
                })
                self.Loading.stopAnimating()
            }
        })
    }
}
