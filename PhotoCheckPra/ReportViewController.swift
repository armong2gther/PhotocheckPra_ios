//
//  ReportViewController.swift
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
import DatePickerDialog

class ReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var start_date: UILabel!
    @IBOutlet weak var end_date: UILabel!
    
    var report_list:JSON?
    
    @IBOutlet weak var reportTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        start_date.text = formatter.string(from: date)
        end_date.text = formatter.string(from: date)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startDatePickerTapped(sender: AnyObject) {
        DatePickerDialog().show(title: "เลือกวันที่เริ่มต้น", doneButtonTitle: "ยืนยัน", cancelButtonTitle: "ยกเลิก", datePickerMode: .date) {
            (date) -> Void in
            let temp = "\(String(describing: date))"
            self.start_date.text = "\(temp.components(separatedBy: " ")[0].replacingOccurrences(of: "Optional(", with: ""))"
        }
    }
    
    @IBAction func endDatePickerTapped(sender: AnyObject) {
        DatePickerDialog().show(title: "เลือกวันที่สิ้นสุด", doneButtonTitle: "ยืนยัน", cancelButtonTitle: "ยกเลิก", datePickerMode: .date) {
            (date) -> Void in
            let temp = "\(String(describing: date))"
            self.end_date.text = "\(temp.components(separatedBy: " ")[0].replacingOccurrences(of: "Optional(", with: ""))"
        }
    }

    @IBAction func doSearch(_ sender: Any) {
        //get_report_person_list.php
        //dateStart
        //dateEnd
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let startdate = dateFormatter.date(from: start_date.text!)
        let enddate = dateFormatter.date(from: end_date.text!)
        if(enddate == nil){
            SCLAlertView().showWarning("ผิดพลาด", subTitle: "วันที่สิ้นสุด จะต้องไม่เป็นค่าว่างค่ะ")
            return
        }
        if(startdate == nil){
            SCLAlertView().showWarning("ผิดพลาด", subTitle: "วันที่เริ่มต้น จะต้องไม่เป็นค่าว่างค่ะ")
            return
        }
        if(enddate! < startdate!){
            let alert = SCLAlertView()
            alert.addButton("แก้ให้ฉัน") {
                self.end_date.text = self.start_date.text!
            }
            alert.showWarning("ผิดพลาด", subTitle: "วันที่สิ้นสุด จะต้องมากกว่าวันที่เริ่มต้นค่ะ")
        }else{
            Alamofire.request("\(HOSTING_URL)get_report_person_list.php", method: .post,parameters: ["dateStart":self.start_date.text!,"dateEnd":self.end_date.text!]).responseJSON {
                response in
                if response.result.isSuccess {
                    print("Get Transfer Success!")
                    self.report_list = JSON(response.result.value!)
                    self.reportTableView.reloadData()
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.report_list == nil){
            return 0
        }else{
            return self.report_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportTableViewCell
        
        if(report_list != nil){
            let each_report = self.report_list?[indexPath.row].dictionaryObject as! [String:Any]
            //let each_transaction = self.transfer_list?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.name_lbl.text = "\(each_report["member_fullname"] as! String)"
            each_cell.review_count.text = "\(each_report["count_review"] as! Int)"
            each_cell.vote_count.text = "\(each_report["count_vote"] as! Int)"
        }
        return each_cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
