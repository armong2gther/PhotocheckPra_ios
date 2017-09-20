//
//  PhotoOverDayViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON
import SCLAlertView

class PhotoOverDayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var album_list:JSON?
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
        // Do any additional setup after loading the view.
    }
    var selectedInfo:[String:String]?
    @IBAction func unwindToOverday (sender: UIStoryboardSegue){
        reloadData()
        print("back to photo over day")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showOverdayAlbum"){
            print("--> prepare OverdayAlbum")
            if let toViewController = segue.destination as? PhotoOverDayDetailViewController {
                toViewController.initInfo = selectedInfo!
            }
        }
    }
    func reloadData(){
        self.getAlbum(url: "\(HOSTING_URL)get_photo_24Hr.php")
    }
    
    func getAlbum(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Album Success!")
                self.album_list = JSON(response.result.value!)
                self.albumTableView.reloadData()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.album_list == nil){
            return 0
        }else{
            return self.album_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "overdayCell") as! PhotoOverDayTableViewCell
        
        if(album_list != nil){
            let each_album = self.album_list?[indexPath.row].dictionaryObject as! [String:String]
            print(each_album)
            each_cell.album_name.text = each_album["pra_name"]
            each_cell.album_date.text = each_album["pra_date_add"]
            each_cell.album_category.text = each_album["cat_name"]
            if let url = NSURL(string: "\(UPLOAD_URL)\(each_album["pra_thumn"]!)") {
                if let data = NSData(contentsOf: url as URL) {
                    each_cell.album_preview.image = UIImage(data: data as Data)
                }
            }
            each_cell.albumInfo = each_album
        }
        return each_cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInfo = self.album_list?[indexPath.row].dictionaryObject as! [String:String]
        self.performSegue(withIdentifier: "showOverdayAlbum", sender: self)
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
