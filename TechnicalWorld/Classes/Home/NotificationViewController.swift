//
//  NotificationViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/11/21.
//

import UIKit

class NotificationViewController: UIViewController {

    
   
    @IBOutlet var tblNotification: UITableView!
    
    var arrNotification = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_GetNotification()
        
        self.tblNotification.delegate = self
        self.tblNotification.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
}

extension NotificationViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        let obj = self.arrNotification[indexPath.row]
        
        cell.lblName.text = obj.strNotificationTitle
        cell.lblDesc.text = obj.strNotification
        cell.lblTimeAgo.text = obj.strTimeAGO
        
        
        let profilePic = obj.strimage.trim()
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgvw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        return cell
    }
    
    
    
    
}


extension NotificationViewController{
    
    //MARK:- Get Banner
    func call_GetNotification(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dict = ["user_id": objAppShareData.UserDetail.strUserId]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetNotification, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{

                    for data in arrData{
                        let obj = NotificationModel.init(dict: data)
                        self.arrNotification.append(obj)
                    }
                    
                    self.tblNotification.reloadData()
                    
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
