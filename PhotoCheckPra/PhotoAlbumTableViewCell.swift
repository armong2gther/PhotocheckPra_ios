//
//  PhotoAlbumTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 8/8/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class PhotoAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var photoAlbumPic: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDatetime: UILabel!
    @IBOutlet weak var albumStatus: UILabel!
    @IBOutlet weak var albumCategory: UILabel!
    
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
