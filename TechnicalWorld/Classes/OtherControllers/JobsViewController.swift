//
//  JobsViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 16/05/21.
//

import UIKit

class JobsViewController: UIViewController {

    @IBOutlet var lblJobsTitile: UILabel!
    @IBOutlet var btnFullTime: UIButton!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwPartTime: UIView!
    @IBOutlet var vwFulltime: UIView!
    @IBOutlet var btnPartTime: UIButton!
    
    
    var strCategoryID = ""
    var strSubCategoryID = ""
    var strType = ""
    var strPostFor = ""
    var arrDetailsSubcategory = [DetailsSubCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        
        if self.strType == "All"{
            self.strSubCategoryID = ""
        }
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_getList(strUserID: userID)
        }
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        
    }
    
    @IBAction func btnOnFullTime(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnOnPartTime(_ sender: Any) {
        
    }
}

extension JobsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDetailsSubcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentTableViewCell")as! RentTableViewCell
        
        let obj = self.arrDetailsSubcategory[indexPath.row]
        
        cell.lblPrice.text = obj.strPrice + " AED"
        cell.lblDetail.text = obj.strDetail
        cell.lblName.text = obj.strName
        cell.lblAddress.text = obj.strLocation
        cell.lblCompaniesRatingCount.text = obj.strRating
        
        
        let profilePic = obj.strImageUrl
        
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgvw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let obj = self.arrDetailsSubcategory[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
       // vc.objDetails = obj
        vc.categoryID = obj.strCategoryID
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


extension JobsViewController{
    
    func call_getList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        
        let param = ["category_id":strCategoryID,
                     "user_id":strUserID,
                     "post_for":self.strPostFor,
                     "sub_category_id":self.strSubCategoryID]as [String:Any]
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPost, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{

                        let obj = DetailsSubCategoryModel.init(dict: dictdata)
                        self.arrDetailsSubcategory.append(obj)
                    }
            
                    self.tblVw.reloadData()
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
