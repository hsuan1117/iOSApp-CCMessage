import UIKit
import Firebase

class Home: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "blue")
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
            } else {
                
            }
        }
    }
}
