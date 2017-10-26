//
//  CheckerManageViewController.swift
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

import FacebookCore
import FacebookLogin
import Firebase
import FirebaseAuth
import GoogleSignIn

class CheckerManageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var checker_list:JSON?
    
    @IBOutlet weak var tableview: UITableView!
    
    fileprivate var panGestures: [UIScreenEdgePanGestureRecognizer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "AdminManager"
        self.navigationController?.isNavigationBarHidden = false

        setupSideMenu()
        reloadData()
        
        // setDefaults()
        // for running all cell -------
        tableview.dataSource = self
        tableview.delegate = self
        // ----------------------------
        
        //
        SCLAnimationStyle.bottomToTop
        
        if let vc = SideMenuManager.menuLeftNavigationController?.viewControllers[0] as? MenuTableViewController
        {
            vc.delegate = self
        }
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        panGestures?.forEach({ (recognizer) in
            recognizer.isEnabled = false
        })
        
    }

    
    func reloadData(){
        self.getCheckerList(url: HOSTING_URL+"get_member_list.php", parameters: ["member_status" : "P"])
//        self.tableview.reloadData()
    }
    
    func getCheckerList(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Connecting Success!")
                
                self.checker_list = JSON(response.result.value!)
                self.tableview.reloadData()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("exit checker")
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChecker (sender: UIStoryboardSegue){
        reloadData()
        print("back to Checker")
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        // MainMenuNavigation
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "MainMenuNavigation") as? UISideMenuNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        panGestures = SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
    }
    
    fileprivate func setDefaults() {
        let styles:UIBlurEffectStyle = .light//[.dark, .light, .extraLight]
        SideMenuManager.menuBlurEffectStyle = styles
    }
    
    @IBAction func showMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.checker_list == nil){
            return 0
        }else{
            return self.checker_list!.count
        }
        //self.checker_list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CheckerTableViewCell

        if(checker_list != nil){
            let each_checker = self.checker_list?[indexPath.row].dictionaryObject as! [String:String]
            each_cell.name_lbl.text! = "\(each_checker["member_fullname"]!) (\(each_checker["member_tel"]!))"
            each_cell.id_lbl.text! = each_checker["member_id"]!
            each_cell.email_lbl.text! = each_checker["member_email"]!
            each_cell.userInfo = each_checker
        }
        return each_cell
    }
    var selectedInfo:[String:String]?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //showdetail
        selectedInfo = self.checker_list?[indexPath.row].dictionaryObject as! [String:String]
        self.performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showdetail"){
            print("--> prepare")
            if let toViewController = segue.destination as? CheckerDetailViewController {
                toViewController.innerUserInfo = selectedInfo
                //myDate = DateFormatter.localizedString(from: dateOutlet.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
            }
        }
    }
    
    // MARK: - insert checker
    
    @IBAction func checkerInsert(_ sender: Any) {
//        SCLAlertView().showInfo("Important info", subTitle: "You are great")
        let alert = SCLAlertView()
        let mail_txt = alert.addTextField("อีเมลล์")
        let pass_txt = alert.addTextField("รหัสผ่าน")
        let name_txt = alert.addTextField("ชื่อ - สกุล")
        let phone_txt = alert.addTextField("เบอร์โทรศัพท์")
        alert.addButton("บันทึก") {
            let params:[String : String] = ["member_email":mail_txt.text!,"member_password":pass_txt.text!,"member_fullname":name_txt.text!,"member_tel":phone_txt.text!,"member_status":"P"]
            Alamofire.request("\(HOSTING_URL)save_member.php", method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("Connecting Success!")
                    
                    let resp = JSON(response.result.value!)
                    if(resp["status"] == "false"){
                        SCLAlertView().showError("Important info", subTitle: "You are great")
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("สำเร็จ", subTitle: "ลงทะเบียนสำเร็จแล้วค่ะ", duration: 3)
                        self.reloadData()
                    }
                    
                } else {
                    print("Error \(response.result.error)")
                }
            }
        }
        SCLAlertViewStyle.edit
        alert.showEdit("เพิ่มข้อมูลผู้ตรวจ", subTitle: "This alert view shows a text box")
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func logoutApp()
    {
        // ต้อง clear token facebook google
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if let topController = self.parent
        {
            if let nc = topController as? UINavigationController
            {
                nc.popToRootViewController(animated: true)
            }
            
        }
    }
    
}

extension CheckerManageViewController: MenuTableViewControllerDeleagte
{
    
    func selectLogoutApp()
    {
        logoutApp()
    }
}
