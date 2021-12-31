//
//  LoginViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
    
    }
    

    @IBAction func btnOnContinue(_ sender: Any) {
//        self.tfEmail.text = "a@yopmail.com"
//        self.tfPassword.text = "qwerty"
        self.validateForSignUp()
      //  self.tfEmail.text = "a@yopmail.com"
    //    self.tfPassword.text = "qwerty"
        
        
      //  self.call_WsLogin()
       
       // self.pushVc(viewConterlerId: "Reveal")
        
    }
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    @IBAction func btnOnRegisterNow(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
    
    @IBAction func btnOnGuest(_ sender: Any) {
        
    }
    
}
    

extension LoginViewController{
    // TextField delegate method
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail{
            self.tfPassword.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPassword{
            self.tfPassword.resignFirstResponder()
        }
        return true
        
    }

}


extension LoginViewController{
    
    //MARK:- All Validations
    func validateForSignUp(){
     
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsLogin()
        }
    }
    
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "type":"user"]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
          //  print(response)
            if status == MessageConstant.k_StatusCode{
                
                let user_details  = response["result"] as? [String:Any]

                //print(user_details)
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                self.pushVc(viewConterlerId: "Reveal")
                
               // ObjAppdelegate.HomeNavigation()
                
                
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
