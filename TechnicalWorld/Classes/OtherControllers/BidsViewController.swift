//
//  BidsViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 14/04/21.
//

import UIKit

class BidsViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    var arrBidList = [BidsListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_getBids(strUserID: userID, strMyID: userID)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        
    }
    @IBAction func btnAllBids(_ sender: Any) {
        
    }
    @IBAction func btnMyBids(_ sender: Any) {
        
    }
   
}

extension BidsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBidList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidsTableViewCell")as! BidsTableViewCell
        
        let obj = self.arrBidList[indexPath.row]
        
        
        let profilePic = obj.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwBid.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lbltitle.text = obj.strTitle
        let date = obj.strDate.split(separator: " ")
        if date.count > 0{
            cell.lblDate.text = "Date: \(date[0])"
            cell.lblTime.text = "Time: \(date[1])"
        }
        
        cell.lblBidBy.text = "By:- \(obj.strName)"
        cell.lblBidCount.text = "Bid : \(obj.strBidsCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailViewController")as! BidDetailViewController
        vc.objData = self.arrBidList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}



extension BidsViewController{
    func call_getBids(strUserID:String, strMyID: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["user_id":"",
                     "my_id":strUserID]as [String:Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetBids, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = BidsListModel.init(dict: dictdata)
                        self.arrBidList.append(obj)
                    }
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if response["result"] as! String == "User not Exist"{
                    self.tblVw.displayBackgroundText(text: "Bids not exist")
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
