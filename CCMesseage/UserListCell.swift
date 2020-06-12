//
//  UserListCell.swift
//  CCMesseage
//
//  Created by student on 2020/6/12.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak var UserUID: UILabel!
    @IBOutlet weak var UserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
