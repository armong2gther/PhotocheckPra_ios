//
//  PhotoStockViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/24/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON
import FacebookCore
import FacebookLogin
import Firebase
import FirebaseAuth
import GoogleSignIn

class PhotoStockViewController: UIViewController {

    fileprivate var panGestures: [UIScreenEdgePanGestureRecognizer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CheckerManager"
        self.navigationController?.isNavigationBarHidden = false
        
        setupSideMenu()
        //setDefaults()
        
        if let vc = SideMenuManager.menuLeftNavigationController?.viewControllers[0] as? CheckerMenuTableViewController
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        // MainMenuNavigation
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "CheckerMenuNavigation") as? UISideMenuNavigationController
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

extension PhotoStockViewController: CheckerMenuTableViewControllerDeleagte
{
    
    func selectLogoutApp()
    {
        logoutApp()
    }
}
