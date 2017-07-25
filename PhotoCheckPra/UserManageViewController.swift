//
//  UserManageViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON

class UserManageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var user_list:JSON?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserList(url: HOSTING_URL+"get_member_list.php", parameters: ["member_status" : "M"])
        // Do any additional setup after loading the view.
    }
    
    func getUserList(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Connecting Success!")
                
                self.user_list = JSON(response.result.value!)
                self.tableView.reloadData()
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
        if(self.user_list == nil){
            return 0
        }else{
            return self.user_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        
        if(user_list != nil){
            let each_checker = self.user_list?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.name_lbl.text! = each_checker["member_fullname"]!
            each_cell.phone_lbl.text! = each_checker["member_tel"]!
            each_cell.email_lbl.text! = each_checker["member_email"]!
            each_cell.credit_lbl.text! = each_checker["member_credit"]!
            print(each_checker)
        }
        return each_cell
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
