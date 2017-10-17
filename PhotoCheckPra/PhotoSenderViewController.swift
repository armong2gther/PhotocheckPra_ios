//
//  PhotoSenderViewController.swift
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

class PhotoSenderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var album_list:JSON?
    
    @IBOutlet weak var useralbumTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "USER"
        self.navigationController?.isNavigationBarHidden = false
        
        
        setupSideMenu()
        //setDefaults()
        self.reloadData()
//        useralbumTableview.dataSource = self
//        useralbumTableview.delegate = self
        // Do any additional setup after loading the view.
        
        if let vc = SideMenuManager.menuLeftNavigationController?.viewControllers[0] as? UserMenuTableViewController
        {
            vc.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func reloadData(){
        self.getAlbum(url: "\(HOSTING_URL)get_my_photo.php")
    }
    
    func getAlbum(url: String){
        Alamofire.request(url, method: .post,parameters: ["userid":"21"]).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Album Success!")
                self.album_list = JSON(response.result.value!)
                self.useralbumTableview.reloadData()
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    @IBAction func unwindToPhotoAlbum (sender: UIStoryboardSegue){
        self.reloadData()
        print("back to PhotoAlbum")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        // MainMenuNavigation
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "UserMenuNavigation") as? UISideMenuNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
       
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.album_list == nil){
            return 0
        }else{
            return self.album_list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let each_cell = tableView.dequeueReusableCell(withIdentifier: "albumlistCell") as! PhotoAlbumTableViewCell
        
        if(album_list != nil){
            let each_album = self.album_list?[indexPath.row].dictionaryObject as! [String:String]
            //print(each_album)
            each_cell.albumName.text = each_album["pra_name"]
            each_cell.albumDatetime.text = each_album["pra_date_add"]
            each_cell.albumCategory.text = each_album["cat_name"]
            let praStatus = each_album["pra_status"]
            var s:String = " [รอการตรวจสอบ]"
            if (praStatus == "draf") {
                s = " [ร่าง]";
            } else if (praStatus == "send") {
                s = " [รอตรวจสอบ]";
            } else if (praStatus == "1") {
                s = " [แท้]";
            } else if (praStatus == "2") {
                s = " [ปลอม]";
            } else if (praStatus == "3") {
                s = " [ขอโหวต]";
            } else if (praStatus == "4") {
                s = " [ส่งตรวจสอบ]";
            }
            each_cell.albumStatus.text = s
            if let url = NSURL(string: "\(UPLOAD_URL)\(each_album["pra_thumn"]!)") {
                if let data = NSData(contentsOf: url as URL) {
                    each_cell.photoAlbumPic.image = UIImage(data: data as Data)
                }
            }
            each_cell.albumInfo = each_album
        }
        return each_cell
    }
    
    fileprivate func setDefaults() {
        let styles:UIBlurEffectStyle = .light//[.dark, .light, .extraLight]
        SideMenuManager.menuBlurEffectStyle = styles
    }
    
    @IBAction func showMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func newAlbum(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewAlbum", sender: self)
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

extension PhotoSenderViewController: UserMenuTableViewControllerDeleagte
{
    
    func selectLogoutApp()
    {
        logoutApp()
    }
}
