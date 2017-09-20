//
//  PhotoOverDayDetailViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import UIImageViewModeScaleAspect

class PhotoOverDayDetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var album_name: UILabel!
    @IBOutlet weak var overdayAlbum: UICollectionView!
    var initInfo:[String:String] = [:]
    var initPhoto:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOverDay()
        album_name.text = initInfo["pra_name"]
        // Do any additional setup after loading the view.
    }
    
    func initOverDay(){
        getPhotoAlbum(url: "\(HOSTING_URL)get_my_photo_album.php",params: ["praId":initInfo["pra_id"]!])
    }
    
    //get_my_photo_album.php
    func getPhotoAlbum(url: String,params:[String:String]){
        Alamofire.request(url, method: .post , parameters : params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Album Success!")
                self.initPhoto = JSON(response.result.value!)
                self.overdayAlbum.reloadData()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToOverDay(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToOverDay", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.initPhoto == nil){
            return 0
        }else{
            return self.initPhoto!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let each_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "overdayCollectionCell", for: indexPath) as! PhotoOverDayCollectionViewCell
        
        if(initPhoto != nil){
            let each_photo = self.initPhoto?[indexPath.row].dictionaryObject as! [String:String]
            print(each_photo)
            if let url = NSURL(string: "\(UPLOAD_URL)\(each_photo["pa_path"]!)") {
                if let data = NSData(contentsOf: url as URL) {
                    each_cell.pra_image.image = UIImage(data: data as Data)
                }
            }
        }
        return each_cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let each_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "overdayCollectionCell", for: indexPath) as! PhotoOverDayCollectionViewCell
        
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
