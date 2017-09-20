//
//  ConsiderationViewController.swift
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

class ConsiderationViewController: UIViewController {

    @IBOutlet weak var credit_lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getConsideration(url: "\(HOSTING_URL)get_rate.php")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //get_rate.php
    func getConsideration(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Get Rate Success!")
                self.credit_lbl.text = (JSON(response.result.value!).dictionaryObject as! [String:String])["rate"]
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    @IBAction func edit_credit(_ sender: Any) {
        let alert = SCLAlertView()
        let rate_txt = alert.addTextField("แก้ไขอัตราค่าตรวจสอบ")
        rate_txt.text = credit_lbl.text?.replacingOccurrences(of: ",", with: "")
        alert.addButton("บันทึก") {
            let params:[String : String] = ["rate":rate_txt.text!]
            Alamofire.request("\(HOSTING_URL)save_rate.php", method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("insert category Success!")
                    
                    let resp = JSON(response.result.value!).dictionaryObject as! [String:String]
                    if(resp["status"] == "false"){
                        SCLAlertView().showError("ไม่สำเร็จ", subTitle: resp["message"]!)
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("สำเร็จ", subTitle: "แก้ไขอัตราค่าตรวจสอบสำเร็จแล้วค่ะ", duration: 1)
                        self.credit_lbl.text = rate_txt.text
                    }
                    
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
        alert.showEdit("อัตราค่าตรวจสอบ", subTitle: "แก้ไขอัตราค่าตรวจสอบ")
    }
    
    @IBAction func showMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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
