//
//  SubmittedOfferViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Dhakad on 03/01/22.
//

import UIKit

class SubmittedOfferViewController: UIViewController {

    @IBOutlet var tblOfferLits: UITableView!
    
    var arrUsers = [UserModel]()
    var strBidId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblOfferLits.delegate = self
        self.tblOfferLits.dataSource = self
        
        self.call_getOfferBid(strBidID: strBidId)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
   

}


extension SubmittedOfferViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmittedOfferTableViewCell")as! SubmittedOfferTableViewCell
        
        let obj = self.arrUsers[indexPath.row]
        
        cell.lblName.text = obj.strUserName
        cell.lblDesc.text = obj.strDescription
        cell.lblPrice.text = obj.strPrice
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openActionSheet(sender: UIButton){
     
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
        
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBidViewController")as! AddBidViewController
//                vc.strBidID = self.arrUsers[sender.tag].strBid_id
//                vc.strSubCategoryID = self.strCategoryID
//                vc.isComingFromEdit = true
//                vc.objEditBidData = self.arrUsers[sender.tag]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
//                if self.myBidClicked == true{
//                    self.call_DeleteBid(strBidID: self.arrUsers[sender.tag].strBid_id)
//                }else{
//                    self.call_DeleteBid(strBidID: self.arrUsers[sender.tag].strBid_id)
//                }
            }))
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
               print("User click Dismiss button")
           }))
        
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
}

extension SubmittedOfferViewController{
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
                        if obj.strUserID == objAppShareData.UserDetail.strUserId{
                            self.arrUsers.append(obj)
                        }else{
                        }
                    }
                    
                    self.tblOfferLits.reloadData()
                    
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
