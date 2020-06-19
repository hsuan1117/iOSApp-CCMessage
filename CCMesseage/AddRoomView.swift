import UIKit
import Firebase
import SwifterSwift
class AddRoomView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var MM = MessageManager()
    var users  : Dictionary<String,String> = [:]
    let db = Firestore.firestore()
    
    @IBOutlet weak var UserListTable: UITableView!
    @IBOutlet weak var NewRoomName: UITextField!
    @IBAction func NewRoomClick(_ sender: Any) {
        if NewRoomName.text == nil {
            showAlert(title: "Error", message: "Please Input the new room name")
        }else{
            var participant : Array<String> = []
            if UserListTable.indexPathForSelectedRow != nil {
                participant.append(Array(users.keys)[UserListTable.indexPathForSelectedRow!.row])
            }
            MM.addRoom(with: participant, name: NewRoomName.text!,completion: {
                self.showAlert(title: "Status", message: "OK! Room \(self.NewRoomName.text!) created successfully")
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserListTable.dequeueReusableCell(withIdentifier: "user_cell") as! UserListCell
        print(users.keys)
        cell.UserName.text = users[Array(users.keys)[indexPath.row]]
        cell.UserUID.text  = Array(users.keys)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(title: "選擇", message: "您選擇了\(users[Array(users.keys)[indexPath.row]] ?? "")")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("users").getDocuments(completion: {
            (snapshot,error) in
            for document in snapshot!.documents {
                if(document.documentID != Auth.auth().currentUser?.uid ){
                    self.users[document.documentID] = (document.data()["name"] as! String)
                }
                
            }
            self.UserListTable.reloadData()
            print(self.users)
        })
        
        UserListTable.delegate = self
        UserListTable.dataSource = self
    }
}
