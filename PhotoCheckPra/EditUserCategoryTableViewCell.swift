//
//  EditUserCategoryTableViewCell.swift
//  PhotoCheckPra
//
//  Created by armong on 7/25/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class EditUserCategoryTableViewCell: UITableViewCell {

    var category_id:String?
    var isCheck:String?
    @IBOutlet weak var check_pic: UIImageView!
    @IBOutlet weak var category_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isCategoryCheck(isCheck: String){
        if(isCheck == "true"){
            check_pic.image = UIImage(named: "logo")
        }else{
            check_pic.image = UIImage(named: "logo_lunch")
        }
    }
    
    func setCategoryCheck(){
        if(self.isCheck == "true"){
            self.isCheck = "false"
            check_pic.image = UIImage(named: "logo_lunch")
        }else{
            self.isCheck = "true"
            check_pic.image = UIImage(named: "logo")
        }
        self.reloadInputViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("select : \(selected)")
        // Configure the view for the selected state
    }

}
