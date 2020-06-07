// Author: Hsuan
// CCMessage

import UIKit
import Firebase
import MessengerKit

class RoomListView: UIViewController {
    // MARK: - Global Variable
    let ACM = AccountManager()
    let MM  = MessageManager()
    var RoomList : [Room] = []
    
    let db = Firestore.firestore();
    var refreshControl:UIRefreshControl!
    
    // MARK: - Private Function
   
    private func getRooms(uid : String) {
        db.collection("users")
            .document(uid)
          .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            for room in (data["rooms"] as! Array<String>) {
                let ref = self.db.collection("rooms").document(room)
                self.RoomList = []
                ref.getDocument{ (doc,error) in
                    print(room)
                    if doc == nil {
                        return
                    }
                    self.RoomList.append(
                        Room(
                            name: doc!["name"] as! String,
                            id: room,
                            participant: doc!["participant"] as! Array<String>
                        )
                    )
                    self.RoomListTable.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - Component Outlet
    @IBOutlet weak var btnNewRoom: UIButton!
    @IBOutlet weak var RoomListTable: UITableView!
    
    
    // MARK: - Component Action
    @IBAction func onAddClick(_ sender: Any) {
        
    }
    
    // MARK: - Storyboard Functions
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pLayer = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        pLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.view.addSubview(pLayer)
        //RoomList.append(Room(name: "Microsoft", id: "123", participant: []))
        ACM.onAuthInit(completion: {
            result in
            if result.user == nil {
                let alert = UIAlertController(title: "警告", message: "你尚未登入", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    (UIAlertAction) in
                     pLayer.isHidden = true
                     self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                //載入訊息
                pLayer.isHidden = true
                self.getRooms(uid: result.user!.uid)
            }
        })
        RoomListTable.delegate   = self
        RoomListTable.dataSource = self
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


// MARK: - TableView
extension RoomListView : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RoomListTable.dequeueReusableCell(withIdentifier: "room_cell") as! RoomListCell
        cell.RoomName.text = RoomList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let MLV = MessageListView()
        MLV.roomID = RoomList[indexPath.row].id
        MLV.roomName = RoomList[indexPath.row].name
        MLV.participant = RoomList[indexPath.row].participant
        let MessageViewController = UINavigationController(rootViewController: MLV)
        MessageViewController.viewControllers.first?.loadViewIfNeeded()
        
        navigationController!.showDetailViewController(MessageViewController, sender: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteItem(at: indexPath.row)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteItem(at:Int) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "刪除") {
            (action,view,handler) in
            self.MM.deleteRoom(id: self.RoomList[at].id, completion: {
                self.showAlert(title: "Status", message: "Room \(self.RoomList[at].name) deleted")
                self.RoomList.remove(at: at)
                self.RoomListTable.reloadData()
            })
        }
        action.backgroundColor = .red
        return action
    }
}

