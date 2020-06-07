import UIKit
import SwifterSwift
class AddRoomView: UIViewController {
    var MM = MessageManager()
    
    @IBOutlet weak var NewRoomName: UITextField!
    @IBAction func NewRoomClick(_ sender: Any) {
        if NewRoomName.text == nil {
            showAlert(title: "Error", message: "Please Input the new room name")
        }else{
            MM.addRoom(with: [], name: NewRoomName.text!,completion: {
                self.showAlert(title: "Status", message: "OK! Room \(self.NewRoomName.text!) created successfully")
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
