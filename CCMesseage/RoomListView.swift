//
//  MessageList.swift
//  CCMesseage
//
//  Created by student on 2020/3/27.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import Firebase
import MessengerKit

class RoomListView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var RoomList : [Room] = []
    let MessageViewController = UINavigationController(rootViewController: MessageListView())
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RoomListTable.dequeueReusableCell(withIdentifier: "room_cell") as! RoomListCell
        cell.RoomName.text = RoomList[indexPath.row].name
        return cell
    }
    
    @IBOutlet weak var btnNewRoom: UIButton!
    @IBOutlet weak var RoomListTable: UITableView!
    
    let ACM = AccountManager()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController!.showDetailViewController(MessageViewController, sender: nil)
    }
    @IBAction func onAddClick(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        MessageViewController.viewControllers.first?.loadViewIfNeeded()
        let pLayer = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        pLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.view.addSubview(pLayer)
        RoomList.append(Room(name: "Microsoft", id: "123"))
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
                
            }
        })
        RoomListTable.delegate   = self
        RoomListTable.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessage" {
            
        }else{
            
        }

    }
}
