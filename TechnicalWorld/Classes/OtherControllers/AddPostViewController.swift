//
//  AddPostViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit
import iOSDropDown

class AddPostViewController: UIViewController,UINavigationControllerDelegate,GetLocationDelegate {
   
    @IBOutlet var imgVwFirst: UIImageView!
    @IBOutlet var imgVwSecond: UIImageView!
    @IBOutlet var imgVwThird: UIImageView!
    @IBOutlet var imgVwRent: UIImageView!
    @IBOutlet var imgVwSell: UIImageView!
    @IBOutlet var tfTypeOfPropert: DropDown!
    @IBOutlet var tfRoom: UITextField!
    @IBOutlet var tfToilet: UITextField!
    @IBOutlet var tfSize: UITextField!
    @IBOutlet var tfFurnishedStatus: DropDown!
    @IBOutlet var tfListedBy: DropDown!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var tfPrice: UITextField!
    @IBOutlet var tfVaidity: DropDown!
    @IBOutlet var tfProperyHeading: UITextField!
    @IBOutlet var txtVw: UITextView!
    @IBOutlet var vwValidity: UIView!
    @IBOutlet var vwValidityInside: UIView!
    
    
    var imagePicker = UIImagePickerController()
    var pickedImageOne:UIImage?
    var pickedImageTwo:UIImage?
    var pickedImageThree:UIImage?
    var isPickedImageFrom = Int()
    var lat = ""
    var long = ""
    var address = ""
    var postFor = ""
    var arrTypesOfCategory = [String]()
    var arrTypesOfCategoryID = [Int]()
    var strTypeOfPropertID = ""
    
    var arrListedBy = ["Broker", "Owner"]
    var arrValidity = ["Monthly", "Yearly"]
    var arrFurnishedStatus = ["Un-Furnished","Semi-Furnished","Full-Furnished"]
    
    var location: Location? {
        didSet {
            self.lblLocation.text = location.flatMap({ $0.title }) ?? "No location selected"
            let cordinates = location.flatMap({ $0.coordinate })
            if (cordinates != nil){
                self.lat = "\(cordinates?.latitude ?? 0.0)"
                self.long = "\(cordinates?.longitude ?? 0.0)"
                self.address = self.lblLocation.text!
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postFor = "Rent"
        self.imagePicker.delegate = self
        self.tfVaidity.delegate = self
        self.tfFurnishedStatus.delegate = self
        // Do any additional setup after loading the view.
        self.call_SubCategory(strCategoryID: "4")
        
        self.setDropDown()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setDropDown(){
        
        self.tfTypeOfPropert.didSelect{(selectedText , index ,id) in
        self.tfTypeOfPropert.text = selectedText
            self.strTypeOfPropertID = "\(id)"
        }
        
        self.tfListedBy.optionArray = self.arrListedBy
        self.tfListedBy.didSelect{(selectedText , index ,id) in
        self.tfListedBy.text = selectedText
        }
        
        self.tfFurnishedStatus.optionArray = self.arrFurnishedStatus
        self.tfFurnishedStatus.didSelect{(selectedText , index ,id) in
        self.tfFurnishedStatus.text = selectedText
        }
        
        self.tfVaidity.optionArray = self.arrValidity
        self.tfVaidity.didSelect{(selectedText , index ,id) in
        self.tfVaidity.text = selectedText
        }
        
    }
    
    @IBAction func btnOpenCamera(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.isPickedImageFrom = sender.tag
        case 1:
            self.isPickedImageFrom = sender.tag
        case 2:
            self.isPickedImageFrom = sender.tag
        default:
            break
        }
        
        self.setImage()
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnopenLocation(_ sender: Any) {
        
        let sb = UIStoryboard.init(name: "LocationPicker", bundle: Bundle.main)
        let locationPicker = sb.instantiateViewController(withIdentifier: "LocationPickerViewController")as! LocationPickerViewController//segue.destination as! LocationPickerViewController
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        
        locationPicker.completion = { self.location = $0 }
        
        self.navigationController?.pushViewController(locationPicker, animated: true)
        
    }
    
    @IBAction func btnOnpost(_ sender: Any) {
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.callWebserviceForAddPostWithImage(strUserID: userID)
        }
    }
    
    
    func getSelectedLocation(dictLocation: [String : Any]) {
        self.lblLocation.text = ""
        self.lat = ""
        self.long = ""
    }
    
    @IBAction func btnOnRent(_ sender: Any) {
        self.vwValidityInside.isHidden = false
        self.imgVwSell.image = #imageLiteral(resourceName: "circle")
        self.imgVwRent.image = #imageLiteral(resourceName: "radio")
        self.postFor = "Rent"
    }
    @IBAction func btnOnSell(_ sender: Any) {
        self.vwValidityInside.isHidden = true
        self.imgVwSell.image = #imageLiteral(resourceName: "radio")
        self.imgVwRent.image = #imageLiteral(resourceName: "circle")
        self.postFor = "Sell"
    }
    
    
}

extension AddPostViewController{
    //MARK:- All Validations
    func validateForAddPost(){
        self.tfProperyHeading.text = self.tfProperyHeading.text!.trim()
        self.tfTypeOfPropert.text = self.tfTypeOfPropert.text!.trim()
        self.tfRoom.text = self.tfRoom.text!.trim()
        self.tfToilet.text = self.tfToilet.text!.trim()
        self.tfSize.text = self.tfSize.text!.trim()
        self.tfListedBy.text = self.tfListedBy.text?.trim()
        self.tfFurnishedStatus.text = self.tfFurnishedStatus.text!.trim()
        self.tfVaidity.text = self.tfVaidity.text!.trim()
        self.tfPrice.text = self.tfPrice.text?.trim()
        self.txtVw.text = self.txtVw.text?.trim()
        
        if (tfTypeOfPropert.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankUserName, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfRoom.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfToilet.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfSize.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        
//        else if self.strType == "company"{
//            if (tfPhoneNumber.text?.isEmpty)! {
//                objAlert.showAlert(message: MessageConstant.BlankPhoneNo, title:MessageConstant.k_AlertTitle, controller: self)
//            }
//        }

        else if (tfListedBy.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Listed By", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfFurnishedStatus.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Furnished Status", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (lblLocation.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Location", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPrice.text?.isEmpty)! {
            objAlert.showAlert(message:"Please Enter Price", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfVaidity.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Validity", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfProperyHeading.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Property Heading", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (txtVw.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Desription", title:MessageConstant.k_AlertTitle, controller: self)
        }

        else{
            let userID = objAppShareData.UserDetail.strUserId
            if userID != ""{
                self.callWebserviceForAddPostWithImage(strUserID: userID)
            }
        }
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate{
    
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
        
        switch isPickedImageFrom {
        case 0:
            if let editedImage = info[.editedImage] as? UIImage {
                
                self.pickedImageOne = editedImage
                self.imgVwFirst.image = self.pickedImageOne

                imagePicker.dismiss(animated: true, completion: nil)
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.pickedImageOne = originalImage
                self.imgVwFirst.image = pickedImageOne
                imagePicker.dismiss(animated: true, completion: nil)
            }
            
        case 1:
            if let editedImage = info[.editedImage] as? UIImage {
                
                self.pickedImageTwo = editedImage
                self.imgVwSecond.image = self.pickedImageTwo

                imagePicker.dismiss(animated: true, completion: nil)
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.pickedImageTwo = originalImage
                self.imgVwSecond.image = pickedImageTwo
                imagePicker.dismiss(animated: true, completion: nil)
            }
        case 2:
            if let editedImage = info[.editedImage] as? UIImage {
                
                self.pickedImageThree = editedImage
                self.imgVwThird.image = self.pickedImageThree

                imagePicker.dismiss(animated: true, completion: nil)
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.pickedImageThree = originalImage
                self.imgVwThird.image = pickedImageThree
                imagePicker.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
        
       
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
    
//    func makeRounded() {
//
//        self.imgVwUser.layer.borderWidth = 0
//        self.imgVwUser.layer.masksToBounds = false
//        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
//        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
//        self.imgVwUser.clipsToBounds = true
//    }
    
}


extension AddPostViewController{
    
    
    func callWebserviceForAddPostWithImage(strUserID: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        var arrImageData = [Data]()
        
        let imgData : Data?
        
        var imgData1 : Data?
        var imgData2 : Data?
        var imgData3 : Data?
        var arrImageParam = [String]()
        
        if self.pickedImageOne != nil{
            imgData1 = (self.pickedImageOne?.jpegData(compressionQuality: 1.0))!
            arrImageData.append(imgData1!)
            arrImageParam.append("image1")
        }
        if self.pickedImageTwo != nil{
            imgData2 = (self.pickedImageTwo?.jpegData(compressionQuality: 1.0))!
            arrImageData.append(imgData2!)
            arrImageParam.append("image2")
        }
        if self.pickedImageThree != nil{
            imgData3 = (self.pickedImageThree?.jpegData(compressionQuality: 1.0))!
            arrImageData.append(imgData3!)
            arrImageParam.append("image3")
        }
        
        
        var dicrParam = [String:Any]()
        
     
            dicrParam = ["post_for":self.postFor,
                         "title":self.tfProperyHeading.text!,
                         "price":self.tfPrice.text!,
                         "validity":self.tfVaidity.text!,
                         "rooms":self.tfRoom.text!,
                         "toilet":self.tfToilet.text!,
                         "category_id":"4",
                         "category_name":"Real State",
                         "sub_category_id":self.strTypeOfPropertID,
                         "sub_category_name":self.tfTypeOfPropert.text!,
                         "location":self.address,
                         "lat":self.lat,
                         "lon":self.long,
                         "size":self.tfSize.text!,
                         "listed_by":self.tfListedBy.text!,
                         "user_id":strUserID]as [String:Any]
        
        
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddPost, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData1, imageToUpload: arrImageData, imagesParam: arrImageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                print(user_details ?? "")

                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message: "Post Add Success", controller: self) {
                    self.onBackPressed()
                }
                

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    //=================XXXX====================//
    
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
                        self.arrTypesOfCategory.append(obj.strSubCategoryName)
                        self.arrTypesOfCategoryID.append(obj.strSubCategoryID)
                    }
                    
                    self.tfTypeOfPropert.optionArray = self.arrTypesOfCategory
                    self.tfTypeOfPropert.optionIds = self.arrTypesOfCategoryID
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
