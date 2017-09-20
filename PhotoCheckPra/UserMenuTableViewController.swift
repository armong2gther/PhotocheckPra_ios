//
//  UserMenuTableViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/24/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit

class UserMenuTableViewController: UITableViewController {

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
                dismiss(animated: true, completion: nil)
                //gotoDest(dest: "FirstView")
            }
        }
    }
    
    func gotoDest(dest: String){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: dest) as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }

}
