//
//  AddBidViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 16/04/21.
//

import UIKit
import iOSDropDown

class AddBidViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var txtVwDescriptioon: RDTextView!
    @IBOutlet weak var tfSelecteCategory: DropDown!
    @IBOutlet var tfSubCategory: DropDown!
    @IBOutlet weak var tfSelectDays: DropDown!
    @IBOutlet var vwSubCategory: UIView!
    
    var arrCategory = [CategoryModel]()
    var arrSubCategory = [SubCategoryModel]()
    var arrBidDetails = [BidsListModel]()
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var arrTypesOfCategory = [String]()
    var arrTypesOfCategoryID = [Int]()
    var arrTypesOfSubCategory = [String]()
    var arrTypesOfSubCategoryID = [Int]()
    var strBidID = ""
    var strSubCategoryID = ""
    
    var strSelectedCategoryID = ""
    var strSelectedSubCategoryID = ""
    
    var isComingFromEdit:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwSubCategory.isHidden = true
        self.tfSelectDays.delegate = self
        self.tfSelecteCategory.delegate = self
        self.imagePicker.delegate = self
        self.call_GetCategory()
      //  self.call_SubCategory(strCategoryID: self.strSubCategoryID)
        hideKeyboardWhenTappedAround()
        if isComingFromEdit{
            self.call_EditBid(strBidID: strBidID)
        }
    //
        self.setData()        
        // Do any additional setup after loading the view.
    }
    
    
    func setData(){
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.lblUserName.text = objAppShareData.UserDetail.strName
        self.lblEmail.text = objAppShareData.UserDetail.strEmail
    }
    
    
    func setDropDown(){
        
        self.tfSelectDays.optionArray = ["1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "7 Days", "8 Days", "9 Days", "10 Days", "11 Days", "12 Days", "13 Days", "14 Days", "15 Days"]
        
        self.tfSelectDays.didSelect{(selectedText , index ,id) in
            self.view.endEditing(true)
        self.tfSelectDays.text = selectedText
        }
        
        self.tfSelecteCategory.didSelect{(selectedText , index ,id) in
            self.view.endEditing(true)
            self.vwSubCategory.isHidden = false
            self.call_SubCategory(strCategoryID: "\(id)")
            self.strSelectedCategoryID = "\(id)"
            self.tfSelecteCategory.text = selectedText
            self.tfSubCategory.text = ""
        }
        
        self.tfSubCategory.didSelect{(selectedText , index ,id) in
            self.view.endEditing(true)
            self.strSelectedSubCategoryID = "\(id)"
            self.tfSubCategory.text = selectedText
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfSelectDays{
            self.view.endEditing(true)
        }
        return true
    }
    
    @IBAction func btnOpenGallery(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnContinue(_ sender: Any) {
        
        self.call_AddBid(strBidId: self.strBidID, strCategoryId: self.strSelectedCategoryID, strSubCategoryId: strSelectedSubCategoryID, strDescription: self.txtVwDescriptioon.text!, strDuration: self.tfSelectDays.text!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AddBidViewController: UIImagePickerControllerDelegate{
    
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
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
          //  self.makeRounded()
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                // self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVw.image = pickedImage
          //  self.makeRounded()
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
    
    //================= Edit Bid ==============//
    
    func call_EditBid(strBidID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
     
        dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                     "my_id":strBidID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_PostEditBid, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = BidsListModel.init(dict: dictdata)
                        
                        self.txtVwDescriptioon.text = obj.strTitle
                        self.tfSelectDays.text = obj.strDuration + " days"
                        self.tfSelecteCategory.text = obj.strCategoryName
                        
                        let profilePic = obj.strImageUrl
                        if profilePic != "" {
                            let url = URL(string: profilePic)
                            self.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                        }
                        
                        let profilePic1 = obj.strUserImage
                        if profilePic1 != "" {
                            let url = URL(string: profilePic1)
                            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                        }
                        
                      //  self.arrBidDetails.append(obj)
                    }
                }
                
                print(response)
               
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    
    //=================XXXX====================//
//https://technicalworld.ae/admin/index.php/api/get_category
    
    
    
    func call_AddBid(strBidId:String, strCategoryId:String, strSubCategoryId: String, strDescription: String, strDuration:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["bid_id":strBidId,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "category_id":strCategoryId,
                         "sub_category_id":strSubCategoryId,
                         "description":strDescription,
                         "duration":strDuration] as [String:Any]
        
        print(dicrParam)
        
        var imageData = [Data]()
        var imgData = Data()
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData)
        
        let imageParam = ["image"]
        
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddBid, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "image", mimeType: "image/jpeg") {
            
            (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
      
                print(response)
                
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Bid Placed Succsfully", controller: self) {
                    self.onBackPressed()
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
               // self.call_GetOffer()
               // self.call_GetBanner()
              //  self.call_SubCategory()
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = CategoryModel.init(dict: dictdata)
                        self.arrTypesOfCategory.append(obj.strCategoryName)
                        self.arrTypesOfCategoryID.append(obj.strCategoryID)
                      //  self.arrCategory.append(obj)
                    }
                    self.tfSelecteCategory.optionArray = self.arrTypesOfCategory
                    self.tfSelecteCategory.optionIds = self.arrTypesOfCategoryID
                    
                    self.setDropDown()
                  //  self.cvCategories.reloadData()
                    
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
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.url_getSubCategory, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                self.arrTypesOfSubCategory.removeAll()
                self.arrTypesOfSubCategoryID.removeAll()
                self.tfSubCategory.optionArray.removeAll()
                self.tfSubCategory.optionIds?.removeAll()
                self.tfSubCategory.selectedRowColor = UIColor.clear
                self.tfSubCategory.checkMarkEnabled = false
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictdata in arrData{
                        
                        let obj = SubCategoryModel.init(dict: dictdata)
                        self.arrTypesOfSubCategory.append(obj.strSubCategoryName)
                        self.arrTypesOfSubCategoryID.append(obj.strSubCategoryID)
                    }
                    
                    self.tfSubCategory.optionArray = self.arrTypesOfSubCategory
                    self.tfSubCategory.optionIds = self.arrTypesOfSubCategoryID
                    
                    self.setDropDown()
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
