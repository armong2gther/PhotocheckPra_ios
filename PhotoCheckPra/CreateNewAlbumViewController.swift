//
//  CreateNewAlbumViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 8/8/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import AnimatedTextInput
import Alamofire
import SwiftyJSON

class CreateNewAlbumViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var cateList:JSON?
    
    @IBOutlet weak var catePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserCategory(url: "\(HOSTING_URL)get_category_list.php")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backto_checker(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToPhotoAlbum", sender: self)
    }
    
    func getUserCategory(url: String ){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Load Category Success!")
                self.cateList = JSON(response.result.value!)
                self.catePicker.reloadAllComponents()
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.cateList == nil){
            return 0
        }else{
            return self.cateList!.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tempo = (self.cateList?[row].dictionaryObject as! [String:String])
//        print(tempo)
        return tempo["cat_name"]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
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
