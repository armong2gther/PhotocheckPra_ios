//
//  PhotoOverDayTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class PhotoOverDayTableViewCell: UITableViewCell {

    @IBOutlet weak var album_name: UILabel!
    @IBOutlet weak var album_date: UILabel!
    @IBOutlet weak var album_category: UILabel!
    @IBOutlet weak var album_preview: UIImageView!
    
    var albumInfo:[String:String] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
