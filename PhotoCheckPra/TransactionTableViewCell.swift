//
//  TransactionTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var pricing_lbl: UILabel!
    @IBOutlet weak var type_lbl: UILabel!
    @IBOutlet weak var mem_id_lbl: UILabel!
    
    @IBOutlet weak var mem_lbl: UILabel!
    
    var transactionInfo:[String:String] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
