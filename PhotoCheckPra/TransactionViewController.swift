//
//  TransactionViewController.swift
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

class TransactionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var transfer_list:JSON?

    @IBOutlet weak var transferTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTransfer(url: "\(HOSTING_URL)get_check_trnasfer.php")
        // Do any additional setup after loading the view.
    }
    var selectedInfo:[String:String]?
    @IBAction func unwindToTransaction (sender: UIStoryboardSegue){
        reloadData()
        print("back to Transaction")
    }
    func reloadData(){
        self.getTransfer(url: "\(HOSTING_URL)get_check_trnasfer.php")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showTransaction"){
            print("--> prepare Transaction")
            if let toViewController = segue.destination as? TransactionDetailViewController {
//                toViewController.innerUserInfo = selectedInfo
                toViewController.transactionInfo = selectedInfo!
                //myDate = DateFormatter.localizedString(from: dateOutlet.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get_check_trnasfer.php
    func getTransfer(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Get Transfer Success!")
                self.transfer_list = JSON(response.result.value!)
                if(self.transfer_list != JSON([])){
                    print("found!")
                    self.transferTableView.reloadData()
                }else{
                    print("not found!")
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showWarning("ไม่พบข้อมูล", subTitle: "ยังไม่มีข้อมูลการโอนเงินขณะนี้ค่ะ", duration: 1.7)
                }
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.transfer_list == nil){
            return 0
        }else{
            return self.transfer_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "transferCell") as! TransactionTableViewCell
        
        if(transfer_list != nil){
            let each_transaction = self.transfer_list?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.mem_lbl.text = each_transaction["member"]
            each_cell.date_lbl.text = each_transaction["transfer_date"]
            each_cell.pricing_lbl.text = each_transaction["price"]
            each_cell.mem_id_lbl.text = each_transaction["member_id"]
            each_cell.type_lbl.text = each_transaction["type"]
            each_cell.transactionInfo = each_transaction
        }
        return each_cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInfo = self.transfer_list?[indexPath.row].dictionaryObject as! [String:String]
        self.performSegue(withIdentifier: "showTransaction", sender: self)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    /*
     n.settMember(jsonobject.getString("member"));
     n.setMemberId(jsonobject.getString("member_id"));
     n.settType(jsonobject.getString("type"));
     n.settDatetTime(jsonobject.getString("transfer_date"));
     n.settPrice(jsonobject.getString("price"));
     n.settRef(jsonobject.getString("ref"));
     n.settId(jsonobject.getString("transf_id"));
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
