//
//  UserMenuTableViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/24/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit


protocol UserMenuTableViewControllerDeleagte {
    func selectLogoutApp()
}

class UserMenuTableViewController: UITableViewController {

    var delegate: UserMenuTableViewControllerDeleagte?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if(indexPath.section == 1){
            if(indexPath.row == 3){
                print("user : logout")
                if delegate != nil
                {
                    delegate?.selectLogoutApp()
                }
            }
        }
    }
    
    
    func gotoDest(dest: String){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: dest) as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }

}
