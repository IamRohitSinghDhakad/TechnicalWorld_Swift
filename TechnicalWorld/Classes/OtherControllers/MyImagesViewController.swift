//
//  MyImagesViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 19/01/22.
//

import UIKit

class MyImagesViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var cvImages: UICollectionView!
    @IBOutlet var btnAddImage: UIButton!
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var vwImageContainer: UIView!
    
    @IBOutlet var vwContainerImgVwFull: UIView!
    @IBOutlet var imgVwFull: UIImageView!
    
    var arrImages = [ServiceImagesModel]()
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
  //  var strType = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwContainerImgVwFull.isHidden = true
        self.vwImageContainer.isHidden = true
        self.imagePicker.delegate = self
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        self.call_UserImage(strUserID: objAppShareData.UserDetail.strUserId, strLoginID: objAppShareData.UserDetail.strUserId)
        
    }
    @IBAction func btnCloseFullImg(_ sender: Any) {
        self.vwContainerImgVwFull.isHidden = true
    }
    
    @IBAction func btnAddImage(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnAddrightTick(_ sender: Any) {
        self.vwImageContainer.isHidden = true
        self.callWebserviceForAddImage()
    }
    
    @IBAction func btnCancelCrossTick(_ sender: Any) {
        self.vwImageContainer.isHidden = true
    }
}


extension MyImagesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyImagesCollectionViewCell", for: indexPath)as! MyImagesCollectionViewCell
        
        let obj = self.arrImages[indexPath.row]
        let profilePic = obj.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        cell.btnDeleteImage.tag = indexPath.row
        cell.btnDeleteImage.addTarget(self, action: #selector(deleteImageAction), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    @objc func deleteImageAction(sender: UIButton){
        let id = self.arrImages[sender.tag].strUser_image_id
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure you want to delete ?", controller: self) {
            self.call_DeleteImage(strDeleteImageId: id)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.arrImages[indexPath.row]
        let profilePic = obj.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwFull.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            self.vwContainerImgVwFull.isHidden = false
        }
        
    }
    
}


extension MyImagesViewController: UIImagePickerControllerDelegate{
    
    // MARK:- UIImage Picker Delegate
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgVw.image = self.pickedImage
            self.vwImageContainer.isHidden = false
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
            self.makeRounded()
//            if self.imgVwUser.image == nil{
//                // self.viewEditProfileImage.isHidden = true
//            }else{
//                // self.viewEditProfileImage.isHidden = false
//            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVw.image = pickedImage
            self.vwImageContainer.isHidden = false
            // self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
//            if self.imgVwUser.image == nil{
//                // self.viewEditProfileImage.isHidden = true
//            }else{
//                //self.viewEditProfileImage.isHidden = false
//            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
    func makeRounded() {
        
//        self.imgVwUser.layer.borderWidth = 0
//        self.imgVwUser.layer.masksToBounds = false
//        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
//        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
//        self.imgVwUser.clipsToBounds = true
    }
    
}

extension MyImagesViewController{
    
    func call_UserImage(strUserID:String,strLoginID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["login_id":strLoginID,
                     "user_id":strLoginID]as [String:Any]
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrImages.removeAll()
                    for dictdata in arrData{

                        let obj = ServiceImagesModel.init(dict: dictdata)
                        self.arrImages.append(obj)
                    }
                    self.cvImages.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                if response["result"] as! String == "Any Image Not Found"{
                    self.cvImages.displayBackgroundText(text: "Any Image Not Found Of This User")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    func callWebserviceForAddImage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["file"]
        
        var dicrParam = [String:Any]()
        
     
        dicrParam = ["type":"image",
                    "user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_addUserImage, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "file", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                self.call_UserImage(strUserID: objAppShareData.UserDetail.strUserId, strLoginID: objAppShareData.UserDetail.strUserId)
               


            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
    
    func call_DeleteImage(strDeleteImageId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["user_image_id":strDeleteImageId]as [String:Any]
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_deleteUserImage, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                self.call_UserImage(strUserID: objAppShareData.UserDetail.strUserId, strLoginID: objAppShareData.UserDetail.strUserId)

            }else{
                objWebServiceManager.hideIndicator()
                if response["result"] as! String == "Any Image Not Found"{
                    self.cvImages.displayBackgroundText(text: "Any Image Not Found Of This User")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
}
