//
//  SubCategoryListViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class SubCategoryListViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var vwRentBuy: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tfSearchBar: UITextField!
    @IBOutlet weak var vwRentBg: UIView!
    @IBOutlet weak var vwBuyBg: UIView!
    
    var categoryID = ""
    var isComingfrom = ""
    var arrSubCategory = [SubCategoryModel]()
    var arrSubCategoryFiltered = [SubCategoryModel]()
    var isType = ""
    var strTtitle = ""
    var strPostFor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.lblTitle.text = self.strTtitle
       
        self.tfSearchBar.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        if isComingfrom == "3"{
            self.isType = "Rent"
            self.vwSearchBar.isHidden = true
            self.vwRentBuy.isHidden = false
        }else{
            self.vwSearchBar.isHidden = false
            self.vwRentBuy.isHidden = true
        }
        
        self.call_SubCategory(strCategoryID: categoryID)
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
    }
    @IBAction func btnOnRent(_ sender: Any) {
        self.isType = "Rent"
        self.vwRentBg.backgroundColor = UIColor.init(named: "lightGreen")
        self.vwBuyBg.backgroundColor = UIColor.white
    }
    @IBAction func btnOnBuy(_ sender: Any) {
        self.isType = "Sell"
        self.vwRentBg.backgroundColor = UIColor.white
        self.vwBuyBg.backgroundColor = UIColor.init(named: "lightGreen")
        
    }
}


extension SubCategoryListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubCategoryFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell")as! SubCategoryTableViewCell
        
        let obj = self.arrSubCategoryFiltered[indexPath.row]
        
        cell.lblSubCategory.text = obj.strSubCategoryName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isComingfrom == "3"{
            let strCategoryID = self.arrSubCategoryFiltered[indexPath.row].strCategoryID
            let strSubCategoryID = self.arrSubCategoryFiltered[indexPath.row].strSubCategoryID
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RentViewController")as! RentViewController
            vc.strCategoryID = strCategoryID
            vc.strSubCategoryID = "\(strSubCategoryID)"
            vc.strType = self.arrSubCategoryFiltered[indexPath.row].strSubCategoryName
            vc.strPostFor = self.isType
            self.navigationController?.pushViewController(vc, animated: true)
        }else if self.isComingfrom == "7"{
            let strCategoryID = self.arrSubCategoryFiltered[indexPath.row].strCategoryID
            var strSubCategoryID = ""
            if self.arrSubCategoryFiltered[indexPath.row].strSubCategoryName == "All"{
                print("set sub category id to  blank ")
            }else{
                strSubCategoryID = "\(self.arrSubCategoryFiltered[indexPath.row].strSubCategoryID)"
            }
           
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsPostListViewController")as! JobsPostListViewController
            vc.strCategoryID = strCategoryID
            vc.strSubCategoryID = strSubCategoryID
            vc.strType = self.isType
            vc.strPostFor = self.strPostFor
            vc.strTitle = "\(self.lblTitle.text!) " + self.arrSubCategoryFiltered[indexPath.row].strSubCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else{
            let strCategoryID = self.arrSubCategoryFiltered[indexPath.row].strCategoryID
            var strSubCategoryID = ""
            if self.arrSubCategoryFiltered[indexPath.row].strSubCategoryName == "All"{
                print("set sub category id to  blank ")
            }else{
                strSubCategoryID = "\(self.arrSubCategoryFiltered[indexPath.row].strSubCategoryID)"
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactListViewController")as! ContactListViewController
            vc.strCategoryID = strCategoryID
            vc.strSubCategoryID = strSubCategoryID
            vc.strType = self.isType
            vc.strPostFor = self.strPostFor
            vc.strTitle = self.arrSubCategoryFiltered[indexPath.row].strSubCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    }
    
}

//MARK:- Searching
extension SubCategoryListViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
        self.arrSubCategoryFiltered.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.arrSubCategory {
                let isMachingWorker : NSString = (dicData.strSubCategoryName) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    self.arrSubCategoryFiltered.append(dicData)
                }
            }
        } else {
            self.arrSubCategoryFiltered = self.arrSubCategory
        }
//        self.arrSubCategoryFiltered = self.arrSubCategoryFiltered.sorted(by: { $0.sort > $1.sort})
        self.tblVw.reloadData()
    }
    
    
}


extension SubCategoryListViewController{
    
    func call_SubCategory(strCategoryID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["category_id":strCategoryID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getSubCategory, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = SubCategoryModel.init(dict: dictdata)
                        self.arrSubCategory.append(obj)
                    }
                    self.arrSubCategoryFiltered = self.arrSubCategory
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
