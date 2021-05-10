//
//  SignUpViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit
import iOSDropDown

class SignUpViewController: UIViewController,UINavigationControllerDelegate,GetLocationDelegate {
   
    

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var imgVwIndividual: UIImageView!
    @IBOutlet weak var imgVwCompany: UIImageView!
    @IBOutlet weak var imgVwCheckUnCheck: UIImageView!
    @IBOutlet weak var vwFullName: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var vwDOB: UIView!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var vwCategory: UIView!
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
    
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var datePicker = UIDatePicker()
    var strType = "individual"
    var arrCategory = [CategoryModel]()
    var arrSubCategory = [SubCategoryModel]()
    var arrCatName = [String]()
    var arrCatID = [Int]()
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgVwCompany.image = #imageLiteral(resourceName: "circle")
        self.imgVwCheckUnCheck.image = #imageLiteral(resourceName: "unc")
        
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        self.tfFullName.delegate = self
        self.tfPhoneNumber.delegate = self
        
        self.vwLocation.isHidden = true
        self.vwCategory.isHidden = true
        self.vwPhoneNumber.isHidden = true
        
        self.imagePicker.delegate = self
        self.showDatePicker()
        self.setDropDown()
        self.call_GetCategory()
        
        hideKeyboardWhenTappedAround()
    }
    
    
    func setDropDown(){
        
        self.tfSelectGender.optionArray = ["Male", "Female", "Other"]
        
        self.tfSelectGender.didSelect{(selectedText , index ,id) in
        self.tfSelectGender.text = selectedText
        }
        
        self.tfSelectCategory.didSelect{(selectedText , index ,id) in
        self.tfSelectCategory.text = selectedText
        }
        
    }
    
    
    @IBAction func btnOnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOnIndividual(_ sender: Any) {
        self.vwLocation.isHidden = true
        self.vwCategory.isHidden = true
        
        self.vwPhoneNumber.isHidden = true
        self.vwDOB.isHidden  = false
        self.vwGender.isHidden = false
        
        self.imgVwCompany.image = #imageLiteral(resourceName: "circle")
        self.imgVwIndividual.image = #imageLiteral(resourceName: "radio")
        
        self.strType = "individual"
    }
    @IBAction func btnOnCompany(_ sender: Any) {
        self.vwLocation.isHidden = false
        self.vwCategory.isHidden = false
        
        self.vwDOB.isHidden  = true
        self.vwGender.isHidden = true
        self.vwPhoneNumber.isHidden = false
        
        self.imgVwCompany.image = #imageLiteral(resourceName: "radio")
        self.imgVwIndividual.image = #imageLiteral(resourceName: "circle")
        
        self.strType = "company"
    }
    
    @IBAction func btnOnTermsOfService(_ sender: Any) {
        
    }
    @IBAction func btnOnPrivacyPolicy(_ sender: Any) {
        
    }
    @IBAction func btnOnContinue(_ sender: Any) {
        validateForSignUp()
    }
    
    @IBAction func btnOnExistingUser(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnOpenLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewViewController")as! MapViewViewController
        vc.delegateOfLocation = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getSelectedLocation(dictLocation: [String : Any]) {
        self.lblLocation.text = ""
        self.lat = ""
        self.long = ""
    }
    
    @IBAction func btnOnOpenDatePicker(_ sender: Any) {
        
    }
    
    @IBAction func btnOnReadCheck(_ sender: Any) {
        if imgVwCheckUnCheck.image == #imageLiteral(resourceName: "unc"){
            imgVwCheckUnCheck.image = #imageLiteral(resourceName: "check")
        }else{
            imgVwCheckUnCheck.image = #imageLiteral(resourceName: "unc")
        }
    }
}

extension SignUpViewController{
    
    func showDatePicker(){
        
        let screenWidth = UIScreen.main.bounds.width
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2

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
        formatter.dateFormat = "yyyy/MM/dd"
        self.tfDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
}


extension SignUpViewController{
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfFullName{
            self.tfEmail.becomeFirstResponder()
            self.tfFullName.resignFirstResponder()
        }
        else if textField == self.tfEmail{
            self.tfPhoneNumber.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPhoneNumber{
            self.tfPassword.becomeFirstResponder()
            self.tfPhoneNumber.resignFirstResponder()
        }
        else if textField == self.tfPassword{
            self.tfPassword.resignFirstResponder()
        }
        return true
    }
    
    

    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfFullName.text = self.tfFullName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfDOB.text = self.tfDOB.text!.trim()
        self.tfPhoneNumber.text = self.tfPhoneNumber.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        self.tfSelectGender.text = self.tfSelectGender.text?.trim()
        
        if (tfFullName.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankUserName, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if self.strType == "company"{
            if (tfPhoneNumber.text?.isEmpty)! {
                objAlert.showAlert(message: MessageConstant.BlankPhoneNo, title:MessageConstant.k_AlertTitle, controller: self)
            }
        }
//        else  if (tfPhoneNumber.text?.isEmpty)! {
//            objAlert.showAlert(message: MessageConstant.BlankPhoneNo, title:MessageConstant.k_AlertTitle, controller: self)
//        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            
            if self.imgVwCheckUnCheck.image == #imageLiteral(resourceName: "check"){
                self.callWebserviceForUploadUserImage()
            }else{
                objAlert.showAlert(message: "Please check terms and condition first", title:MessageConstant.k_AlertTitle, controller: self)
            }
            
           
        }
    }
    
}


extension SignUpViewController: UIImagePickerControllerDelegate{
    
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


//MARK:-  Call WebService
extension SignUpViewController{
    
    func callWebserviceForUploadUserImage(){
        
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
        
        var imageParam = ["user_image"]
        
        var dicrParam = [String:Any]()
        
        if strType == "individual"{
            
            dicrParam = ["name":self.tfFullName.text!,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "dob":self.tfDOB.text!,
                         "sex":self.tfSelectGender.text!,
                         "signup_as":self.strType]as [String:Any]
        }else{
            dicrParam = ["name":self.tfFullName.text!,
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
        
        
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_SignUp, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
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
            
            if status == MessageConstant.k_StatusCode{
               
              //  self.call_SubCategory()
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = CategoryModel.init(dict: dictdata)
                        self.arrCatName.append(obj.strCategoryName)
                        self.arrCatID.append(obj.strCategoryID)
                        self.arrCategory.append(obj)
                    }
                    
                    self.tfSelectCategory.optionArray = self.arrCatName
                    self.tfSelectCategory.optionIds = self.arrCatID
                    
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
