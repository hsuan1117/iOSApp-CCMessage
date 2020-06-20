import UIKit
import Firebase
import SwifterSwift
class AddRoomView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var MM = MessageManager()
    var users  : Dictionary<String,String> = [:]
    var filteredUsers : Dictionary<String,String> = [:]
    let db = Firestore.firestore()
    
    @IBOutlet weak var UserListTable: UITableView!
    @IBOutlet weak var NewRoomName: UITextField!
    @IBAction func NewRoomClick(_ sender: Any) {
        if NewRoomName.text == nil {
            showAlert(title: "Error", message: "Please Input the new room name")
        }else{
            var participant : Array<String> = []
            if UserListTable.indexPathForSelectedRow != nil {
                participant.append(Array(filteredUsers.keys)[UserListTable.indexPathForSelectedRow!.row])
            }
            MM.addRoom(with: participant, name: NewRoomName.text!,completion: {
                self.showAlert(title: "Status", message: "OK! Room \(self.NewRoomName.text!) created successfully")
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserListTable.dequeueReusableCell(withIdentifier: "user_cell") as! UserListCell
        print(users.keys)
        cell.accessoryType = .none
        cell.UserName.text = filteredUsers[Array(filteredUsers.keys)[indexPath.row]]
        cell.UserUID.text  = Array(filteredUsers.keys)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
        }
    }
    
    @IBOutlet weak var SearchController: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("users").getDocuments(completion: {
            (snapshot,error) in
            for document in snapshot!.documents {
                if(document.documentID != Auth.auth().currentUser?.uid ){
                    self.users[document.documentID] = (document.data()["name"] as! String)
                }
            }
            self.filteredUsers = self.users
            self.UserListTable.reloadData()
            //print(self.users)
        })
        
        UserListTable.delegate = self
        UserListTable.dataSource = self
        SearchController.delegate = self
    }
}
extension AddRoomView : UISearchBarDelegate,UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.searchTextField.text?.isEmpty == true{
            self.filteredUsers = users
        }else{
            self.filteredUsers = self.users.filter({
                return $0.key.lowercased().contains(searchBar.searchTextField.text!.lowercased()) || $0.value.lowercased().contains(searchBar.searchTextField.text!.lowercased())
            })
            UserListTable.reloadData()
        }
    }
}
