//
//  UserTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/24/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var credit_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
