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
import FirebaseStorage
import WebKit
class AccountSettingsView: UIViewController {
    let ACM = AccountManager();
    
    @IBOutlet weak var AccountID: UILabel!
    @IBOutlet weak var AccountName: UITextField!
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    @IBOutlet weak var AvatarWK: WKWebView!
    
    @IBAction func ChooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()

        // 委任代理
        imagePickerController.delegate = self

        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)

        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in

            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in

            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }

        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in

            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    
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
            if Auth.auth().currentUser == nil {
                self.showAlert(title: "警告", message: "你沒有登入")
                return
            }
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument(completion: {
                (snapshot,error) in
                self.AccountName.text = snapshot?["name"] as? String ?? ""
                Storage.storage().reference(withPath: snapshot?["avatar"] as? String ?? "").downloadURL(completion: {
                    (url , err) in
                    print(url)
                    self.showAlert(title: "Status", message: "Start downloading avatar")
                    self.AvatarWK.load(URLRequest(url: (url ?? URL(string: "https://lh3.google.com/u/1/ogw/ADGmqu9RVgDVxK6ZDLKKKBVFUD1ub-xkUcyAkPGHu4vf=s64-c-mo"))!))
                })
                self.Loading.stopAnimating()
            })
            self.AccountID.text = "Your ID : \(AuthResult.user?.uid ?? "")"
        })
    }
}
 extension AccountSettingsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        print(uniqueString)
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storageRef = Storage.storage().reference().child("Avatar").child("\(uniqueString).png")
            
            if let uploadData = selectedImage.pngData() {
                // 這行就是 FirebaseStorage 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {
                        
                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let avatar = data?.path{
                        self.ACM.setAvatar(avatar: avatar, completion: {
                            self.showAlert(title: "Status", message: "OK!")
                        })
                        
                        Storage.storage().reference(withPath: avatar).downloadURL(completion: {
                            (url , err) in
                            print(url)
                            self.showAlert(title: "Status", message: "Start downloading avatar")
                            self.AvatarWK.load(URLRequest(url: url!))
                        })
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                print(1)
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
