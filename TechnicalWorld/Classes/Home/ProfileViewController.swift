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
    var strType = ""
    var datePicker = UIDatePicker()
    
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
        self.showDatePicker()
        
        self.strType = objAppShareData.UserDetail.strSignUp_As
        if  self.strType == "individual"{
            self.vwLocation.isHidden = true
            self.vwCategory.isHidden = true
            self.vwSubCategory.isHidden = true
            self.vwDOB.isHidden = false
            self.vwGender.isHidden = false
        }else{
            self.vwLocation.isHidden = false
            self.vwCategory.isHidden = false
            self.vwSubCategory.isHidden = false
            self.vwDOB.isHidden = true
            self.vwGender.isHidden = true
        }
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
    
    
    @IBAction func btnOnContinue(_ sender: Any) {
        if self.pickedImage == nil{
            self.callWebserviceForUpdateProfileWithoutImage()
        }else{
            self.callWebserviceForUpdateProfile()
        }
    }
}

//Cuastom Date Picker
extension ProfileViewController{
    
    func showDatePicker(){
        let screenWidth = UIScreen.main.bounds.width
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.maximumDate = Date()

        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        //ToolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfDOB.inputAccessoryView = toolBar
        self.tfDOB.inputView = datePicker
        
    }

      @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        self.tfDOB.text = formatter.string(from: datePicker.date)
      //  let age  = getAgeFromDOF(date: self.tfDOB.text!)
      //  self.intYear = (age.0)
      //  self.intMonth = (age.1)
      //  self.intDay = (age.2)
        self.view.endEditing(true)
       
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
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


extension ProfileViewController{
    func callWebserviceForUpdateProfile(){
        
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
        
        let imageParam = ["user_image"]
        
        var dicrParam = [String:Any]()
        
        if strType == "individual"{
            
            dicrParam = ["name":self.tfFullName.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "dob":self.tfDOB.text!,
                         "sex":self.tfSelectGender.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "signup_as":self.strType]as [String:Any]
        }else{
            dicrParam = ["name":self.tfFullName.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "dob":self.tfDOB.text!,
                         "sex":self.tfSelectGender.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "category_id":"",
                         "category_name":"",
                         "sub_category_id":"",
                         "sub_category_name":"",
                         "address":"",
                         "lat":"",
                         "lon":"",
                         "signup_as":self.strType]as [String:Any]
        }
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_UpdateProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                print(user_details ?? "")
                
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                self.pushVc(viewConterlerId: "Reveal")


            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
    
    //========================= Update Profile without Image ===========================//
    func callWebserviceForUpdateProfileWithoutImage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var dicrParam = [String:Any]()
        
        if strType == "individual"{
            
            dicrParam = ["name":self.tfFullName.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "dob":self.tfDOB.text!,
                         "sex":self.tfSelectGender.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "signup_as":self.strType]as [String:Any]
        }else{
            dicrParam = ["name":self.tfFullName.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "dob":self.tfDOB.text!,
                         "sex":self.tfSelectGender.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "category_id":"",
                         "category_name":"",
                         "sub_category_id":"",
                         "sub_category_name":"",
                         "address":"",
                         "lat":"",
                         "lon":"",
                         "signup_as":self.strType]as [String:Any]
        }
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_UpdateProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { response
            in

            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                print(user_details ?? "")
                
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                self.pushVc(viewConterlerId: "Reveal")


            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
}
