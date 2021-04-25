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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVwContacts.delegate = self
        self.tblVwContacts.dataSource = self
        
        self.subVwSort.isHidden = true
        
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
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        return cell
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
                     "user_id":strUserID,
                     "sub_category_id":strSubCategoryID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserList, params: param, queryParams: [:], strCustomValidation: "") { (response) in
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
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
}
