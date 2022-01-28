//
//  RentViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class RentViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var vwBtns: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    var strCategoryID = ""
    var strSubCategoryID = ""
    var strType = ""
    var strPostFor = ""
    var arrDetailsSubcategory = [DetailsSubCategoryModel]()
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwSearchBar.isHidden = true
        
        self.lblTitle.text = self.strTitle
        
        if self.strType == "All"{
            self.strSubCategoryID = ""
        }
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_getList(strUserID: userID)
        }
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        self.pushVc(viewConterlerId: "Reveal")
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }

}

extension RentViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDetailsSubcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentTableViewCell")as! RentTableViewCell
        
        let obj = self.arrDetailsSubcategory[indexPath.row]
        
        cell.lblPrice.text = obj.strPrice + " AED  \(obj.strValidity)"
        cell.lblDetail.text = obj.strHeading
        cell.lblName.text = obj.strName
        cell.lblAddress.text = obj.strLocation
        cell.lblCompaniesRatingCount.text = obj.strRating
        
    
        let profilePic = obj.strBaseUrl + obj.strImageURL1.trim()//obj.strImageUrl
        
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgvw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let obj = self.arrDetailsSubcategory[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RentDetailViewController")as! RentDetailViewController
        vc.objDetails = obj
       
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


extension RentViewController{
    
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
