//
//  ContactListViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class ContactListViewController: UIViewController {

    @IBOutlet weak var subVwSort: UIView!
    @IBOutlet weak var tblVwContacts: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
  
    var arrUserList = [UserModel]()
    var strCategoryID = ""
    var strSubCategoryID = ""
    var strType = ""
    var strPostFor = ""
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVwContacts.delegate = self
        self.tblVwContacts.dataSource = self
        
        self.lblTitle.text = self.strTitle.localized()
        
        self.subVwSort.isHidden = true
        print(strCategoryID, strType, strPostFor)
        if self.strType == "All"{
            self.strSubCategoryID = ""
        }
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_UserList(strCategoryID: self.strCategoryID, strSubCategoryID: self.strSubCategoryID, strUserID: userID)
        }
    
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
        
    }
    @IBAction func btnOnCamcelSubVw(_ sender: Any) {
        self.subVwSort.isHidden = true
    }
    
    @IBAction func btnOnLocation(_ sender: Any) {
        
    }
    @IBAction func btnOnSort(_ sender: Any) {
        self.subVwSort.isHidden = false
        
    }
    
    @IBAction func btnActionSortData(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("high to low")
        case 1:
            print("low to high")
        case 2:
            print("high to low Individual")
        case 3:
            print("low to High Individual")
        default:
            break
        }
    }
    
}


extension ContactListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell")as! ContactListTableViewCell
        
        let obj = self.arrUserList[indexPath.row]
        
        cell.lblUserName.text = obj.strUserName
        cell.lblCategoryName.text = obj.strUserSubCategory + " \(obj.strUserCategory)"
        
        cell.ratingVwCompany.rating = Double(obj.strRatingCompany) ?? 0.0
        cell.ratingVwindividual.rating = Double(obj.strRatingIndividual) ?? 0.0
        cell.lblCountRatingCompany.text = "(\(obj.strReviewCompany))"
        cell.lblCountRatingIndividual.text = "(\(obj.strReviewIndividual))"
        cell.lblCompanies.text = "Companies : \(obj.strRatingCompany)"
        cell.lblIndividuals.text = "Individual : \(obj.strRatingIndividual)"
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        cell.btnWhatsApp.tag = indexPath.row
        cell.btnWhatsApp.addTarget(self, action: #selector(openCallWhatsApp), for: .touchUpInside)
        
        cell.btnCall.tag = indexPath.row
        cell.btnCall.addTarget(self, action: #selector(openCallDialer), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openCallWhatsApp(sender: UIButton){
        let number = self.arrUserList[sender.tag].strPhoneNumber
        let name = self.arrUserList[sender.tag].strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to chat with \(name) on whatsapp?", controller: self) {
            self.openWhatsApp(strPhoneNumber: number)
        }
        
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController")as! DetailViewController
        vc.objUser = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ContactListViewController{
    
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
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserList, params: param, queryParams: [:], strCustomValidation: "") { (response) in
     //   objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserList, params: param, queryParams: [:], strCustomValidation: "") { (response) in
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
                    self.tblVwContacts.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if response["result"] as! String == "User not Exist"{
                    self.tblVwContacts.displayBackgroundText(text: "User not Exist")
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
