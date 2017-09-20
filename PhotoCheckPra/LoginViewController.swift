//
//  LoginViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import AnimatedTextInput
import Alamofire
import SwiftyJSON
import SideMenu

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: AnimatedTextInput!
    @IBOutlet weak var password: AnimatedTextInput!
    
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToDestinationViewControllerWithSender", sender: self)
    }
    
    func auth_login(url: String, parameters: [String: String]) {
        var authIsSuccess = 0
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Connecting Success!")
                
                let resp : JSON = JSON(response.result.value!)
                print(resp)
                print(resp["status"])
                if(resp["status"] == "true"){
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminManager") as UIViewController
                    self.present(viewController, animated: true, completion: nil)
                }
            } else {
                print("Error \(response.result.error)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        username.accessibilityLabel = "standard_text_input"
        username.placeHolderText = "Username"
        username.textColor = UIColor.black
        
        password.placeHolderText = "Password"
        password.type = .password(toggleable: true)
        
        setupSideMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        // MainMenuNavigation
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "MainMenuNavigation") as? UISideMenuNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
    }

    @IBAction func checkLogin(_ sender: Any) {
        print("check login")
        let param:[String:String] = ["email":username.text!,"password":password.text!]
        self.auth_login(url: HOSTING_URL+"chklogin.php", parameters: param)
//        if(res){
//            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckerManager") as UIViewController
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    // MARK: - Test Login button
    @IBAction func adminLogin(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminManager") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func checkerLogin(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckerManager") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func userLogin(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserManager") as UIViewController
        self.present(viewController, animated: true, completion: nil)
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
