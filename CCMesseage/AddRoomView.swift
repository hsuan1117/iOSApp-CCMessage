import UIKit

class AddRoomView: UIViewController {
    var MM = MessageManager()
    
    @IBAction func NewRoomClick(_ sender: Any) {
        MM.addRoom(with: [], name: "test")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
