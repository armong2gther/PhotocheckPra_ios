//
//  CheckerDetailViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/21/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import AnimatedTextInput
import Alamofire
import SwiftyJSON
import SCLAlertView
import SwiftCheckboxDialog

class CheckerDetailViewController: UIViewController, CheckboxDialogViewDelegate {
    
    @IBOutlet weak var email_inp: AnimatedTextInput!
    @IBOutlet weak var name_inp: AnimatedTextInput!
    @IBOutlet weak var phone_inp: AnimatedTextInput!
    
    var checkboxDialogViewController: CheckboxDialogViewController!
    
    var innerUserInfo:[String:String]?
    var userCate:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email_inp.placeHolderText = "อีเมลล์"
        
        email_inp.text = (innerUserInfo?["member_email"])!
        email_inp.textColor = UIColor.black
//        email_inp.text//: CGFloat = 11
        name_inp.placeHolderText = "ชื่อ - นามสกุล"
        name_inp.text = (innerUserInfo?["member_fullname"])!
        name_inp.textColor = UIColor.black
        
        phone_inp.placeHolderText = "เบอร์โทรศัพท์"
        phone_inp.text = (innerUserInfo?["member_tel"])!
        phone_inp.textColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToCheckerDetail (sender: UIStoryboardSegue){
        print("back to Checker Detail")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backto_checker(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToChecker", sender: self)
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        let params:[String:String] = ["member_id":innerUserInfo!["member_id"]!,"member_email":email_inp.text!,"member_fullname":name_inp.text!,"member_tel":phone_inp.text!]
        Alamofire.request("\(HOSTING_URL)save_edit_member.php", method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let resp = JSON(response.result.value!)
                if(resp["status"] == "false"){
                    SCLAlertView().showError("Important info", subTitle: "You are great")
                }else{
                    SCLAlertView().showSuccess("Important info", subTitle: "You are great")
                }
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    @IBAction func delChecker(_ sender: Any) {
        Alamofire.request("\(HOSTING_URL)save_del_member.php", method: .post, parameters: ["member_id":innerUserInfo!["member_id"]!]).responseJSON {
            response in
            if response.result.isSuccess {
                let resp = JSON(response.result.value!)
                if(resp["status"] == "false"){
                    SCLAlertView().showError("Important info", subTitle: "You are great")
                }else{
                    SCLAlertView().showSuccess("Important info", subTitle: "You are great")
                }
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    @IBAction func categoryChange(_ sender: UIButton) {
        self.getUserCategory(url: "\(HOSTING_URL)get_member_category.php",parameters: ["member_id":(innerUserInfo?["member_id"])!])
    }
    
    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary,isConfirm:Bool) {
        if(isConfirm){
            var selected:String = ""
            for each in values {
                if (selected == "") {
                    selected = "\(each.key)"
                } else {
                    selected = "\(selected),\(each.key)"
                }
            }
            let params = [ "cat_list":selected, "member_id":(innerUserInfo?["member_id"])! ]
            self.sendCategoryUpdate(url: "\(HOSTING_URL)save_person_category.php",parameters: params)
        }
        
    }
    
    func sendCategoryUpdate(url: String, parameters: [String: String]){
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Update Category Success!")
                let resp = JSON(response.result.value!)
                print(resp)
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func getUserCategory(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Category Success!")
                self.userCate = JSON(response.result.value!)
                self.prepareAlert()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func transferData() -> [(String,String)] {
        var answer:[(String,String)] = []
        for tmp in (userCate?.array)!  {
            let dt = tmp.dictionaryObject as! [String:String]
            answer.append((dt["cat_id"]!,dt["cat_name"]!))
        }
        return answer
    }

    func isCheckCategory(tableData:[(String,String)]) -> [(String,String)]{
        var answer:[(String,String)] = []
        for tmp in (userCate?.array)!  {
            let dt = tmp.dictionaryObject as! [String:String]
            if(dt["cat_chk"] == "true"){
                answer.append((dt["cat_id"]!, dt["cat_name"]!))
            }
        }
        return answer
    }
    
    func prepareAlert(){
        let tableData :[(name: String, translated: String)] = self.transferData()
        
        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "หมวดหมู่"
        self.checkboxDialogViewController.tableData = tableData
        self.checkboxDialogViewController.defaultValues = self.isCheckCategory(tableData: tableData)
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.countries
        self.checkboxDialogViewController.delegateDialogTableView = self as! CheckboxDialogViewDelegate
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
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
