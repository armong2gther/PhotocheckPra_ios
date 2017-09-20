//
//  TransactionDetailViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var member_name: UILabel!
    @IBOutlet weak var transaction_type: UILabel!
    @IBOutlet weak var transaction_date: UILabel!
    
    @IBOutlet weak var transaction_price: UITextField!
    
    @IBOutlet weak var transaction_preview: UIImageView!
    
    var transactionInfo:[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(transactionInfo)
        self.initTransaction()
        // Do any additional setup after loading the view.
    }
    
    func initTransaction(){
        member_name.text = transactionInfo["member"]
        transaction_type.text = transactionInfo["type"]
        transaction_date.text = transactionInfo["transfer_date"]
        
        transaction_price.text = transactionInfo["price"]
        
        if let url = NSURL(string: "\(HOSTING_URL)\(transactionInfo["ref"]!)") {
            if let data = NSData(contentsOf: url as URL) {
                transaction_preview.image = UIImage(data: data as Data)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptTransaction(_ sender: Any) {
        print("Accept")
        let alert = SCLAlertView()
        alert.addButton("ยืนยัน") {
            self.saveCreditCheck(status: "1")
        }
        let tmp = transaction_price.text as! NSString
        alert.showWarning("ยืนยันการทำรายการ", subTitle: "ทำการเพิ่มเครดิตให้ เป็นจำนวน \(tmp)")
    }
    @IBAction func rejectTransaction(_ sender: Any) {
        print("Reject")
        let alert = SCLAlertView()
        alert.addButton("แน่ใจ ยกเลิกเลย") {
            self.saveCreditCheck(status: "2")
        }
        alert.showWarning("ยืนยันการทำรายการ", subTitle: "ทำการยกเลิกรายการเครดิต")
    }
    func saveCreditCheck(status:String){
        //"save_check_credit.php"
        
        let params = ["approveStatus":status,"transfer_id":transactionInfo["transf_id"]!,"price":transaction_price.text!,"userid":transactionInfo["member_id"]!]
        print(params)
        Alamofire.request("\(HOSTING_URL)save_check_credit.php", method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Get Rate Success!")
                let resp = JSON(response.result.value!).dictionaryObject as! [String:String]
                if(resp["status"] == "true"){
                    print(resp["message"])
//                    self.transferTableView.reloadData()
                    let alertView = SCLAlertView()
                    alertView.showSuccess("สำเร็จ", subTitle: resp["message"]!, duration: 1.5)
                    self.performSegue(withIdentifier: "unwindToTransaction", sender: self)
                }else{
                    print(resp["message"])
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showWarning("ไม่สำเร็จ", subTitle: resp["message"]!, duration: 1.5)
                }
                
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    @IBAction func backToTransaction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToTransaction", sender: self)
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
