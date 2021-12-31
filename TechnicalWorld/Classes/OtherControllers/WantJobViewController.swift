//
//  WantJobViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit
import iOSDropDown

class WantJobViewController: UIViewController {

    @IBOutlet var vwYearOfexperience: UIView!
    @IBOutlet var vwOtherQualification: UIView!
    @IBOutlet var vwLastCurrentJob: UIView!
    @IBOutlet var vwLookingForRole: UIView!
    @IBOutlet var vwWhatCanIDo: UIView!
    @IBOutlet var vwOtherBenifits: UIView!
    @IBOutlet var vwExpectedFees: UIView!
    @IBOutlet var vwTotalHours: UIView!
    @IBOutlet var vwExpectedMonthlySalery: UIView!
    @IBOutlet var imgVwFullTime: UIImageView!
    @IBOutlet var imgVwPartTime: UIImageView!
    @IBOutlet var tfDescription: UITextField!
    @IBOutlet var tfField: DropDown!
    @IBOutlet var tfDegree: DropDown!
    @IBOutlet var tfOtherQualification: UITextField!
    @IBOutlet var tfYearOfExperience: UITextField!
    @IBOutlet var tfWhatCanIDo: UITextField!
    @IBOutlet var tfLastCurrentJob: UITextField!
    @IBOutlet var tfLookingForeRole: UITextField!
    @IBOutlet var tfmonthly: DropDown!
    @IBOutlet var tfExpectedFees: UITextField!
    @IBOutlet var tfExpectedMonthlySalery: UITextField!
    @IBOutlet var tfExpectedMonthlySaleryTo: UITextField!
    @IBOutlet var tfTotalhours: UITextField!
    @IBOutlet var tfWeekly: DropDown!
    @IBOutlet var tfOtherBenifits: UITextField!
    
    var isPartTime = Bool()
    var postFor = ""
    var strSubCatID = ""
    var arrTypesOfCategory = [String]()
    var arrTypesOfCategoryID = [Int]()
    var arrDegree = ["Associate Degree","Bachelor's Degree","Master's Degree","Doctoral Degree"]
    var arrDays = ["Day","Week","Month"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_SubCategory(strCategoryID: "7")
        self.postFor = "Full Time"
        self.vwWhatCanIDo.isHidden = true
        self.vwExpectedFees.isHidden = true
        self.vwTotalHours.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setDropDown(){
        
        self.tfDegree.optionArray = self.arrDegree
        self.tfDegree.didSelect{(selectedText , index ,id) in
        self.tfDegree.text = selectedText
        }
        
        self.tfField.optionArray = self.arrTypesOfCategory
        self.tfField.didSelect{(selectedText , index ,id) in
        self.tfField.text = selectedText
        }
        
        self.tfmonthly.optionArray = self.arrDays
        self.tfmonthly.didSelect{(selectedText , index ,id) in
        self.tfmonthly.text = selectedText
        }
        
        self.tfWeekly.optionArray = self.arrDays
        self.tfWeekly.didSelect{(selectedText , index ,id) in
        self.tfWeekly.text = selectedText
        }
        
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
        
    }
    
    @IBAction func btnOnPost(_ sender: Any) {
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_WantJob(strUserID: userID)
        }
    }
    
    @IBAction func btnOnFullTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "radio")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "circle")
        
        self.isPartTime = false
        
        self.vwWhatCanIDo.isHidden = true
        self.vwExpectedFees.isHidden = true
        self.vwTotalHours.isHidden = true
        
        self.vwExpectedMonthlySalery.isHidden = false
        self.vwOtherQualification.isHidden = false
        self.vwLastCurrentJob.isHidden = false
        self.vwLookingForRole.isHidden = false
        self.vwOtherBenifits.isHidden = false
        
    }
    
    @IBAction func btnOnPartTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "circle")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "radio")
        
        self.isPartTime = true
        
        self.vwWhatCanIDo.isHidden = false
        self.vwExpectedFees.isHidden = false
        self.vwTotalHours.isHidden = false
        
        self.vwExpectedMonthlySalery.isHidden = true
        self.vwOtherQualification.isHidden = true
        self.vwLastCurrentJob.isHidden = true
        self.vwLookingForRole.isHidden = true
        self.vwOtherBenifits.isHidden = true
    }
    
}

extension WantJobViewController{
    //MARK:- All Validations
    func validateForAddPost(){
        self.tfDescription.text = self.tfDescription.text!.trim()
        self.tfField.text = self.tfField.text!.trim()
        self.tfDegree.text = self.tfDegree.text!.trim()
        self.tfOtherQualification.text = self.tfOtherQualification.text!.trim()
        self.tfYearOfExperience.text = self.tfYearOfExperience.text!.trim()
        self.tfWhatCanIDo.text = self.tfWhatCanIDo.text?.trim()
        self.tfLastCurrentJob.text = self.tfLastCurrentJob.text!.trim()
        self.tfLookingForeRole.text = self.tfLookingForeRole.text!.trim()
        self.tfExpectedFees.text = self.tfExpectedFees.text?.trim()
        self.tfExpectedMonthlySalery.text = self.tfExpectedMonthlySalery.text?.trim()
        self.tfExpectedMonthlySaleryTo.text = self.tfExpectedMonthlySaleryTo.text?.trim()
        self.tfmonthly.text = self.tfmonthly.text?.trim()
        self.tfWeekly.text = self.tfWeekly.text?.trim()
        self.tfOtherBenifits.text = self.tfOtherBenifits.text?.trim()
        
        if (tfDescription.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Description", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfField.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Field", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfDegree.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Degree", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfOtherQualification.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Qualification", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfYearOfExperience.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Year of Experience", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfWhatCanIDo.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter what can yo do", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfLastCurrentJob.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter your last job", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfLookingForeRole.text?.isEmpty)! {
            objAlert.showAlert(message:"Please Enter looking for job role", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfExpectedFees.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Expected Fees", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfExpectedMonthlySalery.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Property Heading", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfExpectedMonthlySaleryTo.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Enter Desription", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfmonthly.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Monthly", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfWeekly.text?.isEmpty)! {
            objAlert.showAlert(message: "Please Select Weekly", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfOtherBenifits.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter other benifits", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            let userID = objAppShareData.UserDetail.strUserId
            if userID != ""{
               // self.callWebserviceForAddPostWithImage(strUserID: userID)
            }
        }
    }
}



extension WantJobViewController{
    
    func call_WantJob(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
        
     
            dicrParam = ["post_for":self.postFor,
                         "type":"Want",
                         "offer_desc":self.tfDescription.text!,
                         "degree":self.tfDegree.text!,
                         "qualification":self.tfOtherQualification.text!,
                         "experience":self.tfYearOfExperience.text!,
                         "category_id":"7",
                         "category_name":"Jobs",
                         "sub_category_id":self.strSubCatID,
                         "sub_category_name":self.tfField.text!,
                         "last_job":self.tfLastCurrentJob.text!,
                         "looking_for":self.tfLookingForeRole.text!,
                         "min_amount":self.tfExpectedMonthlySalery.text!,
                         "max_amount":self.tfExpectedMonthlySaleryTo.text!,
                         "remark":"",
                         "user_id":strUserID]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddPost, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Job Posted Succesfully", controller: self) {
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
    
    //=============XXX============//
    
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
    
}
