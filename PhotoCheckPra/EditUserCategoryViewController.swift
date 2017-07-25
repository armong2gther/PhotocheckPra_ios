//
//  EditUserCategoryViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/25/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditUserCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var userCate:JSON?
    var user_id:String?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserCategory(url: "\(HOSTING_URL)get_member_category.php",parameters: ["member_id":user_id!])
        
    }
    
    func getUserCategory(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Category Success!")
                
                self.userCate = JSON(response.result.value!)
                print(self.userCate)
//                self.tableview.delegate = self
//                self.tableview.dataSource = self
                self.tableview.reloadData()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.userCate == nil){
            return 0
        }else{
            return self.userCate!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! EditUserCategoryTableViewCell
        
        if(userCate != nil){
            let each_category = self.userCate?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.category_id = each_category["cat_id"]
            each_cell.category_name.text = each_category["cat_name"]
            each_cell.isCategoryCheck(isCheck: each_category["cat_chk"]!)
        }
        return each_cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! EditUserCategoryTableViewCell
        each_cell.setCategoryCheck()
    }
    
    @IBAction func back_tocheckerdetail(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToCheckerDetail", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
