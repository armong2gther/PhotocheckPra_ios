//
//  MenuTableViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit


class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section : \(indexPath.section) idx : \(indexPath.row)")
        
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                print("checker manager")
//                gotoDest(dest: "CheckerManager")
//                dismiss(animated: true, completion: nil)
                print("close success")
            }
            if(indexPath.row == 1){
                print("checker user")
                //gotoDest(dest: "")
            }
            if(indexPath.row == 2){
                print("transaction")
                //gotoDest(dest: "")
            }
            if(indexPath.row == 3){
                print("report")
                //gotoDest(dest: "")
            }
        }
        
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                print("consideration")
                //gotoDest(dest: "")
            }
            if(indexPath.row == 1){
                print("category")
                //gotoDest(dest: "")
            }
            if(indexPath.row == 2){
                print("profile")
                //gotoDest(dest: "")
            }
            if(indexPath.row == 3){
                print("logout")
                //self.performSegue(withIdentifier: "unwindToDestinationViewControllerWithSender", sender: self)
                //gotoDest(dest: "FirstView")
//                dismiss(animated: true, completion: nil)
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstView") as! UIViewController
//                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        }
        //dismiss(animated: true, completion: nil)
    }
    
    func gotoDest(dest: String){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: dest) as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }

    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 4
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//        print("section : \(indexPath.section) idx : \(indexPath.row)")
//
//        return cell
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
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
