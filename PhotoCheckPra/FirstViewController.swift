//
//  FirstViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu

class FirstViewController: UIViewController {
    
    
    @IBAction func unwindToDestinationViewController (sender: UIStoryboardSegue){
        print("back")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SideMenuManager.menuLeftNavigationController = nil
        self.navigationController?.isNavigationBarHidden = true
        //self.view.reloadInputViews()
       
        // Do any additional setup after loading the view.
        //ScreenEdgePanGestures
        
        if let recognizers = self.view.gestureRecognizers {
            for gesture in recognizers {
                // This check for UIPanGestureRecognizer but you can check for the one you need
                if let gRecognizer = gesture as? UIPanGestureRecognizer {
                    print("Gesture recognizer found")
                    self.view.removeGestureRecognizer(gRecognizer)
                }
            }
        }
//        let tt  = self. as UIScreenEdgePanGestureRecognizer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func facebook_auth(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FacebookAuth") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func google_auth(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleAuth") as UIViewController
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
