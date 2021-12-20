//
//  OfferJobViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit
import iOSDropDown

class OfferJobViewController: UIViewController {
    
    @IBOutlet var tfOfferDesc: UITextField!
    @IBOutlet var txtVwWriteHere: RDTextView!
    @IBOutlet var tfMinimumQualification: DropDown!
    @IBOutlet var tfField: DropDown!
    @IBOutlet var tfMinimumYear: UITextField!
    @IBOutlet var tfOfferRole: UITextField!
    @IBOutlet var lblOfferedText: UILabel!
    @IBOutlet var tfPackage: UITextField!
    @IBOutlet var imgVwFullTime: UIImageView!
    @IBOutlet var imgVwPartTime: UIImageView!
    @IBOutlet var vwOtherBenifits: UIView!
    
    var arrDegree = ["Associate Degree","Bachelor's Degree","Master's Degree","Doctoral Degree"]
    var arrTypesOfCategory = [String]()
    var arrTypesOfCategoryID = [Int]()
    
    var strType = "FullTime"
    var isPartTime = Bool()
    var postFor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblOfferedText.text = "Offered Package"
        self.vwOtherBenifits.isHidden = true
        
        self.call_SubCategory(strCategoryID: "7")
        self.setDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func setDropDown(){
        
        self.tfMinimumQualification.optionArray = self.arrDegree
        self.tfMinimumQualification.didSelect{(selectedText , index ,id) in
        self.tfMinimumQualification.text = selectedText
        }
    
        self.tfField.optionArray = self.arrTypesOfCategory
        self.tfField.didSelect{(selectedText , index ,id) in
        self.tfField.text = selectedText
        }
        
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnFullTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "radio")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "circle")
        
        self.lblOfferedText.text = "Offered Package"
        self.vwOtherBenifits.isHidden = true
        
        self.strType = "FullTime"
    }
    
    @IBAction func btnOnpartTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "circle")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "radio")
        
        self.lblOfferedText.text = "Offered Salary"
        self.vwOtherBenifits.isHidden = false
        
        self.strType = "PartTime"
    }
    
    @IBAction func btnOnPost(_ sender: Any) {
        
    }

}

extension OfferJobViewController{
    //MARK:- All Validations
    func validateForAddPost(){
        self.tfOfferDesc.text = self.tfOfferDesc.text!.trim()
        self.tfField.text = self.tfField.text!.trim()
        self.tfMinimumQualification.text = self.tfMinimumQualification.text!.trim()
        self.tfMinimumYear.text = self.tfMinimumYear.text!.trim()
        self.tfOfferRole.text = self.tfOfferRole.text!.trim()
        self.tfPackage.text = self.tfPackage.text?.trim()
        self.txtVwWriteHere.text = self.txtVwWriteHere.text!.trim()
        
        if (tfOfferDesc.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Description", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfMinimumQualification.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Degree", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfField.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Field", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfMinimumYear.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Minimum Year of Experience", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfOfferRole.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Offered Role", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPackage.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Salery", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if strType == "PartTime"{
            if (txtVwWriteHere.text?.isEmpty)! {
                objAlert.showAlert(message: "Please Enter Other Benifits", title:MessageConstant.k_AlertTitle, controller: self)
            }
        }
        else{
            let userID = objAppShareData.UserDetail.strUserId
            if userID != ""{
                self.call_OfferJob(strUserID: userID)
               // self.callWebserviceForAddPostWithImage(strUserID: userID)
            }
        }
    }
}


//MARK:- Get Category
extension OfferJobViewController{
    
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
                    
                    self.tfField.optionArray = self.arrTypesOfCategory
                    self.tfField.optionIds = self.arrTypesOfCategoryID
                    
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
    
    
    func call_OfferJob(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
        
     
            dicrParam = ["post_for":self.postFor,
                         "type":"Offer",
                         "offer_desc":self.tfOfferDesc.text!,
                       //  "degree":self.tfDegree.text!,
                         "qualification":self.tfMinimumQualification.text!,
                         "experience":self.tfMinimumYear.text!,
                         "category_id":"7",
                         "category_name":"Jobs",
                       //  "sub_category_id":self.strSubCatID,
                         "sub_category_name":self.tfField.text!,
                       //  "last_job":self.tfLastCurrentJob.text!,
                         "looking_for":self.tfOfferRole.text!,
                     //    "min_amount":self.tfExpectedMonthlySalery.text!,
                       //  "max_amount":self.tfExpectedMonthlySaleryTo.text!,
                        // "remark":"self.tfListedBy.text!",
                         "user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddPost, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Offer Job Posted Succesfully", controller: self) {
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
    
}
