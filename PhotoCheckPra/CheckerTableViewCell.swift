//
//  CheckerTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/21/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class CheckerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var id_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    
    var userInfo:[String:String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
