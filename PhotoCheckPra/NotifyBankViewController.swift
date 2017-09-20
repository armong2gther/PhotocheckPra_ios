//
//  NotifyBankViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu

class NotifyBankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToNotify (sender: UIStoryboardSegue){
        print("back to Notify Bank")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showOverdayAlbum"){
            print("--> prepare Notify Detail")
//            if let toViewController = segue.destination as? NotifyBankDetailViewController {
//                
//            }
        }
    }
    @IBAction func showNotifyDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "showNotify", sender: self)
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
