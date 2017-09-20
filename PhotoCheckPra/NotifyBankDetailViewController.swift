//
//  NotifyBankDetailViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/26/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import AnimatedTextInput
import MMUploadImage
import Alamofire
import SwiftyJSON
import SCLAlertView

class NotifyBankDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var preview_image: UIImageView!
    
    @IBOutlet weak var date_tranfer: AnimatedTextInput!
    @IBOutlet weak var time_transfer: AnimatedTextInput!
    @IBOutlet weak var amount_transfer: AnimatedTextInput!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let imageCamera =  UIImagePickerController()
        imageCamera.delegate = self
        imageCamera.sourceType = .camera
        self.present(imageCamera, animated: true, completion: nil)
    }
    
    @IBAction func fromLibrary(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let img = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.progress = 0.1
            self.preview_image.image = img
//            self.imgView.uploadImage(image:preview_image.image, progress: 0)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmNotify(_ sender: Any) {
        //"\(UPLOAD_URL)upload_pra.php"
        let params = [
            "date":date_tranfer.text!,
            "time":time_transfer.text!,
            "money":amount_transfer.text!,
            "user":"21",
            "result":"my_image"
        ]
        self.doUpload(url:"\(UPLOAD_URL)upload_bank.php",parameters: params,image:preview_image.image!)
    }
    func doUpload(url: String, parameters: [String: String],image:UIImage){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                    if  let imageData = UIImageJPEGRepresentation(image, 0.6) {
                        multipartFormData.append(imageData, withName: "uploaded_file", fileName: "\(parameters["date"])\(parameters["money"])image\(parameters["user"]).jpeg", mimeType: "image/jpeg")
                        //print("img + 1")
                    }
        },
            to: url,
            method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        //print(progress.completedUnitCount)
                    })
                    upload.responseJSON { response in
                        if response.result.isSuccess{
                            print("Upload Success!")
                            let resp = JSON(response.result.value!)
                            var btn_name:String?
                            var stat:String?
                            var msg:String?
                            if(resp["result"] == "success"){
                                btn_name = "ยืนยัน"
                                stat = "สำเร็จ"
                                msg = "ทำการแจ้งโอนเงินสำเร็จแล้วค่ะ"
                            }else{
                                btn_name = "ยกเลิก"
                                stat = "ล้มเหลว"
                                msg = "ไม่สามารถทำรายการได้กรุณาลองใหม่ค่ะ"
                            }
                            let alert = SCLAlertView()
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            alertView.addButton(btn_name!) {
                                self.performSegue(withIdentifier: "unwindToNotify", sender: self)
                            }
                            if(resp["result"] == "success"){
                                alertView.showSuccess(stat!, subTitle: msg!)
                            }else{
                                alertView.showError(stat!, subTitle: msg!)
                            }
                        } else {
                            print("Error \(response.result.error)")
                        }
                    }
                case .failure(let encodingError):
                    print("FALLE ------------")
                }
            }
        )
    }
    
    @IBAction func backtoNotifyBank(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToNotify", sender: self)
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
