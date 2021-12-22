//
//  SubmitOfferViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 16/04/21.
//

import UIKit
import SDWebImage

class SubmitOfferViewController: UIViewController {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtVw: RDTextView!
    @IBOutlet weak var tfPrice: UITextField!
    
    var strBidID:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.lblCategory.text = objAppShareData.UserDetail.strCategory
        
     
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnContinue(_ sender: Any) {
        self.call_SubmitBid(strBidID: self.strBidID, strPrice: self.tfPrice.text!, strDescription: self.txtVw.text!)
    }
}


extension SubmitOfferViewController{
    
    func call_SubmitBid(strBidID:String,strPrice:String,strDescription:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        
        let param = ["bid_id":strBidID,
                     "user_id":objAppShareData.UserDetail.strUserId,
                     "price":strPrice,
                     "description":strDescription] as [String:Any]
        
     print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_OfferBid, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false) { response in

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let dictData  = response["result"] as? [String:Any]{
                   
      
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Your bid offer submit succesfully.", controller: self) {
                        self.onBackPressed()
                    }
                    
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
