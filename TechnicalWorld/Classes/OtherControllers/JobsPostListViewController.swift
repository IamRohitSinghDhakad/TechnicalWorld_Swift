//
//  JobsPostListViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 31/12/21.
//

import UIKit

class JobsPostListViewController: UIViewController {
    
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var tblPostList: UITableView!
 
    
    var arrUserList = [UserModel]()
    var strCategoryID = ""
    var strSubCategoryID = ""
    var strType = ""
    var strPostFor = ""
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblPostList.delegate = self
        self.tblPostList.dataSource = self
        
        self.lbltitle.text = self.strTitle
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_UserList(strCategoryID: self.strCategoryID, strSubCategoryID: self.strSubCategoryID, strUserID: userID)
        }
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
}


extension JobsPostListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsPostListTableViewCell")as! JobsPostListTableViewCell
        
        let obj = self.arrUserList[indexPath.row]
        
        if self.strType == "Offer"{
            cell.vwUserImage.isHidden = true
            cell.vwCallingButtons.isHidden = true
            
            cell.lblTitle.text = obj.strOfferDesc
            cell.lblField.text = "Field : " + obj.strUserSubCategory
            cell.lblDegree.text = "Required Degree : " + obj.strDegree
            cell.lblJobtype.text = "Job Type : " + obj.strPostFor
            cell.lblExperience.text = "Min. Experience Required : " + obj.strExperience + " Years"
            if obj.strFeesUnit == ""{
                cell.lblAED.text =  obj.strFees + " AED per Month"
            }else{
                cell.lblAED.text =  obj.strFees + " AED per " + obj.strFeesUnit
            }
            cell.lblAED.isHidden = false
            
        }else{
            cell.vwUserImage.isHidden = false
            cell.vwCallingButtons.isHidden = false
            
            cell.lblTitle.text = obj.strUserName
            cell.lblField.text = "Field : " + obj.strUserSubCategory
            cell.lblDegree.text = "Degree : " + obj.strDegree
            cell.lblJobtype.text = "Job Type : " + obj.strPostFor
            cell.lblExperience.text = obj.strMinAmount + " - " + obj.strMaxAmount + " AED per month"
            cell.lblAED.isHidden = true//text =  obj.strWorkingHour + " Hours per " + obj.strWorkingHourUnit
            
            let profilePic = obj.strUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
            cell.btnWhatsapp.tag = indexPath.row
            cell.btnWhatsapp.addTarget(self, action: #selector(openCallWhatsApp), for: .touchUpInside)
            
            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action: #selector(openCallDialer), for: .touchUpInside)
        }
        
     
        
        return cell
    }
    
    @objc func openCallWhatsApp(sender: UIButton){
        let number = self.arrUserList[sender.tag].strPhoneNumber
        let name = self.arrUserList[sender.tag].strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to chat with \(name) on whatsapp?", controller: self) {
            self.openWhatsApp(strPhoneNumber: number)
        }
        
      // openWhatsApp(strPhoneNumber: number)
    }
    
    @objc func openCallDialer(sender: UIButton){
        let number = self.arrUserList[sender.tag].strPhoneNumber
        let name = self.arrUserList[sender.tag].strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to call \(name) ?", controller: self) {
            self.callNumber(phoneNumber: number)
        }
    }
    
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    func openWhatsApp(strPhoneNumber:String){
        let phoneNumber =  strPhoneNumber // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            let appURLL = URL(string: "https://wa.me/\(strPhoneNumber)")!
            if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURLL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURLL)
                }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrUserList[indexPath.row]
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController")as! DetailViewController
//        vc.objUser = obj
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralAccountantViewController")as! GeneralAccountantViewController
        vc.objUser = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsPostListViewController{
 
    func call_UserList(strCategoryID:String,strSubCategoryID:String,strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["category_id":strCategoryID,
                     "type":self.strType,
                     "post_for":self.strPostFor,
                     "user_id":strUserID,
                     "sub_category_id":strSubCategoryID]as [String:Any]

        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPost, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = UserModel.init(dict: dictdata)
                        self.arrUserList.append(obj)
                    }
                    self.tblPostList.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if response["result"] as! String == "User not Exist"{
                    self.tblPostList.displayBackgroundText(text: "User not Exist")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
}
