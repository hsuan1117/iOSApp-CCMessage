import UIKit
import FirebaseAuth
import SwifterSwift

class AccountView: UIViewController {
    var ACM = AccountManager()
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputAccount: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAnonymous: UIButton!
    
    @IBAction func OnclickAnonymous(_ sender: Any) {
        ACM.loginAnonymous(completion: {
            result in
            if result.error != nil{
                self.showAlert(title: "Error", message: result.error?.localizedDescription)
            }
            if result.auth != nil {
                self.showAlert(title: "Succeed", message: "Login Succeed")
            }
        })
    }
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
        
        let pLayer = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        pLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.view.addSubview(pLayer)
        ACM.onAuthInit(completion: {
            result in
            if result.user == nil {
                pLayer.isHidden = true
            } else {
               //已登入
                let alert = UIAlertController(title: "警告", message: "你已經登入", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    (UIAlertAction) in
                    pLayer.isHidden = true
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
