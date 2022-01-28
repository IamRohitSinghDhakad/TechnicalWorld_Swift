//
//  GiveReviesViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class GiveReviesViewController: UIViewController,FloatRatingViewDelegate {

    
    var objUser:UserModel?
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblHowWas: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var txtVwReview: RDTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.ratingView.emptyImage = ima
        
        let profilePic = objUser?.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.lblUserName.text = objUser?.strUserName
        self.lblHowWas.text = "How was the experience with \(objUser?.strUserName ?? "")"
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        self.txtVwReview.text = self.txtVwReview.text?.trim()
        
       if self.txtVwReview.text == ""{
           objAlert.showAlert(message: "Please enter review.", title: "Alert", controller: self)
        }else{
            self.call_GiveReview(strUserID: objAppShareData.UserDetail.strUserId)
        }
       
       // pushVc(viewConterlerId: "AddJobPostViewController")
    }
    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print(rating)
        self.ratingView.rating = rating
    }
}

extension GiveReviesViewController{
    
    func call_GiveReview(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
        
     
        dicrParam = [ "user_id":objUser?.strUserID ?? "",
                      "bid_id":objUser?.strBidId ?? "",
                      "rating_by":strUserID,
                      "rating":"\(ratingView.rating)",
                      "review":self.txtVwReview.text!,
                      
            ]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GiveReview, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Review Submitted Succesfully.", controller: self) {
                    self.pushVc(viewConterlerId: "Reveal")
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
