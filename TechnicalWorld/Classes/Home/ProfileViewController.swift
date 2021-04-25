//
//  ProfileViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit
import iOSDropDown
import SDWebImage

class ProfileViewController: UIViewController,UINavigationControllerDelegate,GetLocationDelegate {
   
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var vwFullName: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var vwDOB: UIView!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var vwSubCategory: UIView!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var tfFullName:
        UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tfSelectGender: DropDown!
    @IBOutlet weak var tfSelectCategory: DropDown!
    @IBOutlet weak var tfSubCategory: DropDown!
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var arrCategory = [String]()
    var arrSubCategory = [String]()
    var arrCategoryID = [Int]()
    var arrSubCategoryID = [Int]()
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfSelectGender.delegate = self
        self.tfSelectCategory.delegate = self
        self.tfSubCategory.delegate = self
        
        hideKeyboardWhenTappedAround()
        self.imagePicker.delegate = self
        self.call_GetCategory()
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_GetProfile(strUserID: userID)
        }
        
        self.setDropDown()
    }
    
    func setDropDown(){
        
        self.tfSelectGender.optionArray = ["Male", "Female", "Other"]
        
        self.tfSelectGender.didSelect{(selectedText , index ,id) in
        self.tfSelectGender.text = selectedText
        }
        
        self.tfSelectCategory.didSelect{(selectedText , index ,id) in
            self.tfSelectCategory.text = selectedText
            self.arrSubCategory.removeAll()
            self.arrSubCategoryID.removeAll()
            self.call_SubCategory(strCategoryID: "\(id)")
        }
        
        self.tfSubCategory.didSelect{(selectedText , index ,id) in
        self.tfSubCategory.text = selectedText
        }
        
    }
    
    
    
    func setUserData(){
        
        self.tfFullName.text = objAppShareData.UserDetail.strUserName
        self.tfEmail.text = objAppShareData.UserDetail.strEmail
        self.tfPhoneNumber.text = objAppShareData.UserDetail.strPhoneNumber
        self.tfPassword.text = objAppShareData.UserDetail.strPassword
        self.tfSelectCategory.text = objAppShareData.UserDetail.strCategory
        self.tfSubCategory.text = objAppShareData.UserDetail.strSubCategory
        self.lblLocation.text = objAppShareData.UserDetail.strAddress
        self.tfDOB.text = objAppShareData.UserDetail.strDob
        self.tfSelectGender.text = objAppShareData.UserDetail.strGender
        
        
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOpenLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewViewController")as! MapViewViewController
        vc.delegateOfLocation = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSelectedLocation(dictLocation: [String : Any]) {
        self.lblLocation.text = dictLocation["address"]as? String ?? ""
        self.lat = dictLocation["latitude"]as? String ?? ""
        self.long = dictLocation["longitude"]as? String ?? ""
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate{
    
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
            self.imgVwUser.image = self.pickedImage
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
            self.makeRounded()
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                // self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
            self.makeRounded()
            // self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                //self.viewEditProfileImage.isHidden = false
            }
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
        
        self.imgVwUser.layer.borderWidth = 0
        self.imgVwUser.layer.masksToBounds = false
        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        self.imgVwUser.clipsToBounds = true
    }
    
}

extension ProfileViewController{
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
           // self.showAlerOnAppDelegate(strMessage: "No Internet Connection")
            return
        }
    
      //  objWebServiceManager.showIndicator()
        
       
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                self.setUserData()
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "Failed", title: "Alert", controller: self)
                }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }

    
   }
    
    func call_GetCategory(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getCategory, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
               
                
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = CategoryModel.init(dict: dictdata)
                        self.arrCategory.append(obj.strCategoryName)
                        self.arrCategoryID.append(obj.strCategoryID)
                    }
                    
                    self.tfSelectCategory.optionArray = self.arrCategory
                    self.tfSelectCategory.optionIds = self.arrCategoryID
                   
                    
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    func call_SubCategory(strCategoryID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["category_id":strCategoryID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getSubCategory, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = SubCategoryModel.init(dict: dictdata)
                        self.arrSubCategory.append(obj.strSubCategoryName)
                        self.arrSubCategoryID.append(obj.strSubCategoryID)
                    }
                    
                    self.tfSubCategory.optionArray = self.arrSubCategory
                    self.tfSubCategory.optionIds = self.arrSubCategoryID
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }

    
   }
}
