//
//  ReportTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var review_count: UILabel!
    @IBOutlet weak var vote_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
