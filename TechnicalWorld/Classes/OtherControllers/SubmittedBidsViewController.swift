//
//  SubmittedBidsViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Dhakad on 23/12/21.
//

import UIKit

class SubmittedBidsViewController: UIViewController {

    @IBOutlet var tblUsers: UITableView!
    
    var arrUsers = [UserModel]()
    var strBidId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblUsers.delegate = self
        self.tblUsers.dataSource = self
        
        self.call_getOfferBid(strBidID: self.strBidId)
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
}


extension SubmittedBidsViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmittedTableViewCell")as! SubmittedTableViewCell
        
        let obj = self.arrUsers[indexPath.row]
        
        cell.lblName.text = obj.strUserName
        cell.lblAmount.text = obj.strPrice
        cell.lblDescription.text  = obj.strDescription
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.btnWhatsapp.tag = indexPath.row
        cell.btnWhatsapp.addTarget(self, action: #selector(openCallWhatsApp), for: .touchUpInside)
        
        cell.btnCall.tag = indexPath.row
        cell.btnCall.addTarget(self, action: #selector(openCallDialer), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubmittedBidsUsersViewController")as! SubmittedBidsUsersViewController
        vc.objUser = self.arrUsers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func openCallWhatsApp(sender: UIButton){
        let number = self.arrUsers[sender.tag].strPhoneNumber
        let name = self.arrUsers[sender.tag].strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to chat with \(name) on whatsapp?", controller: self) {
            self.openWhatsApp(strPhoneNumber: number)
        }
        
      // openWhatsApp(strPhoneNumber: number)
    }
    
    @objc func openCallDialer(sender: UIButton){
        let number = self.arrUsers[sender.tag].strPhoneNumber
        let name = self.arrUsers[sender.tag].strUserName
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
    
    
    
    func call_getOfferBid(strBidID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
            dicrParam = ["bid_id":strBidID]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetOfferBid, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                if let result = response["result"] as? [[String:Any]]{
                    
                    
                    for data in result{
                        let obj = UserModel.init(dict: data)
                        self.arrUsers.append(obj)
                    }
                    
                    self.tblUsers.reloadData()
                    
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





