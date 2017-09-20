//
//  PhotoCategoryViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON
import SCLAlertView

class PhotoCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var category_list:JSON?
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoryList(url: "\(HOSTING_URL)get_category_list.php")
        // Do any additional setup after loading the view.
    }
    
    func reloadData(){
        self.getCategoryList(url: "\(HOSTING_URL)get_category_list.php")
//        self.tableview.reloadData()
    }
    
    func getCategoryList(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Connecting Success!")
                
                self.category_list = JSON(response.result.value!)
                self.categoryTableView.reloadData()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.category_list == nil){
            return 0
        }else{
            return self.category_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let each_cell = tableView.cellForRow(at:indexPath) as! PhotoCategoryTableViewCell
        let temp = each_cell.category_info
        let alert = SCLAlertView()
        let cat_name_txt = alert.addTextField("หมวดหมู่ภาพถ่าย")
        cat_name_txt.text = temp?["cat_name"]
        alert.addButton("บันทึก") {
            let params:[String : String] = ["cat_id":temp!["cat_id"]!,"cat_name":cat_name_txt.text!]
            Alamofire.request("\(HOSTING_URL)save_edit_category.php", method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("edit category Success!")
                    
                    let resp = JSON(response.result.value!).dictionaryObject as! [String:String]
                    if(resp["status"] == "false"){
                        SCLAlertView().showError("ไม่สำเร็จ", subTitle: resp["message"]!)
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("สำเร็จ", subTitle: "แก้ไขหมวดหมู่สำเร็จแล้วค่ะ", duration: 1)
                        self.reloadData()
                    }
                    
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
        alert.addButton("ลบ") {
            let params:[String : String] = ["cat_id":temp!["cat_id"]!]
            Alamofire.request("\(HOSTING_URL)save_del_category.php", method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("delete category Success!")
                    
                    let resp = JSON(response.result.value!).dictionaryObject as! [String:String]
                    if(resp["status"] == "false"){
                        SCLAlertView().showError("ไม่สำเร็จ", subTitle: resp["message"]!)
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("สำเร็จ", subTitle: "ลบหมวดหมู่สำเร็จแล้วค่ะ", duration: 1)
                        self.reloadData()
                    }
                    
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
        let id = temp?["cat_id"]
        alert.showEdit("หมวดหมู่ภาพถ่าย", subTitle: "แก้ไขข้อมูลหมวดหมู่ภาพถ่าย (\(id))")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! PhotoCategoryTableViewCell
        
        if(category_list != nil){
            let each_category = self.category_list?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.category_name.text! = each_category["cat_name"]!
            each_cell.category_info = each_category
        }
        return each_cell
    }
    
    @IBAction func addCategory(_ sender: Any) {
        let alert = SCLAlertView()
        let cat_name_txt = alert.addTextField("หมวดหมู่ภาพถ่าย")
        alert.addButton("บันทึก") {
            let params:[String : String] = ["cat_name":cat_name_txt.text!]
            Alamofire.request("\(HOSTING_URL)save_category.php", method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("insert category Success!")
                    
                    let resp = JSON(response.result.value!)
                    if(resp["status"] == "false"){
                        SCLAlertView().showError("ไม่สำเร็จ", subTitle: "กรุณาลองใหม่อีกครั้งค่ะ")
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("สำเร็จ", subTitle: "เพิ่มหมวดหมู่สำเร็จแล้วค่ะ", duration: 1)
                        self.reloadData()
                    }
                    
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
        alert.showEdit("แก้ไขข้อมูลหมวดหมู่ภาพถ่าย", subTitle: "เพิ่มข้อมูลหมวดหมู่ภาพถ่าย")
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
