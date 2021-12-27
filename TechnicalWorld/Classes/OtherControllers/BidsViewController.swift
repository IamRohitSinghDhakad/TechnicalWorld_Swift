//
//  BidsViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 14/04/21.
//

import UIKit

class BidsViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vwContainAddBid: UIView!
    @IBOutlet var vwAllBids: UIView!
    @IBOutlet var vwMyBids: UIView!
    @IBOutlet var btnAllBids: UIButton!
    @IBOutlet var btnMyBids: UIButton!
    
    
    var myBidClicked:Bool?
    var arrBidList = [BidsListModel]()
    var arrMyBidList = [BidsListModel]()
    var strCategoryID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwContainAddBid.isHidden = true
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_getBids(strUserID: userID, strMyID: userID)
        }
    }
    
    
    func resetColor(){
        self.vwAllBids.backgroundColor = UIColor.white
        self.vwMyBids.backgroundColor = UIColor.white
        self.btnAllBids.backgroundColor = UIColor.black
        self.btnMyBids.backgroundColor = UIColor.black
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        self.pushVc(viewConterlerId: "Reveal")
    }
    
    @IBAction func btnAllBids(_ sender: Any) {
        self.vwContainAddBid.isHidden = true
        self.myBidClicked = false
        self.tblVw.reloadData()
        
//        self.vwAllBids.backgroundColor = UIColor.init(named: "lightGreen")
//        self.btnAllBids.backgroundColor = UIColor.black
//        self.vwMyBids.backgroundColor = UIColor.white
//        self.btnMyBids.backgroundColor = UIColor.black
        self.vwAllBids.backgroundColor = UIColor.init(named: "lightGreen")
        self.vwMyBids.backgroundColor = UIColor.white
        self.btnMyBids.setTitleColor(UIColor.black, for: .normal)
        self.btnAllBids.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnMyBids(_ sender: Any) {
        self.vwContainAddBid.isHidden = false
        self.myBidClicked = true
        self.tblVw.reloadData()
        
        self.vwMyBids.backgroundColor = UIColor.init(named: "lightGreen")
        self.vwAllBids.backgroundColor = UIColor.white
        self.btnMyBids.setTitleColor(UIColor.white, for: .normal)
        self.btnAllBids.setTitleColor(UIColor.black, for: .normal)
        
//        self.vwAllBids.backgroundColor =  UIColor.white
//        self.vwMyBids.backgroundColor = UIColor.init(named: "lightGreen")
//        self.btnAllBids.backgroundColor = UIColor.black
//        self.btnMyBids.backgroundColor = UIColor.white
    }
    
    @IBAction func btnAddBid(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBidViewController")as! AddBidViewController
        vc.strSubCategoryID = self.strCategoryID
        vc.isComingFromEdit = false
        self.navigationController?.pushViewController(vc, animated: true)
      //  pushVc(viewConterlerId: "AddBidViewController")
    }
}

extension BidsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myBidClicked == true{
            return self.arrMyBidList.count
        }else{
            return self.arrBidList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidsTableViewCell")as! BidsTableViewCell
        
        let obj:BidsListModel?
        if self.myBidClicked == true{
             obj = self.arrMyBidList[indexPath.row]
            cell.vwThreeDots.isHidden = false
        }else{
             obj = self.arrBidList[indexPath.row]
            cell.vwThreeDots.isHidden = true
        }
        
        let profilePic = obj?.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic!)
            cell.imgVwBid.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lbltitle.text = obj?.strTitle
        let date = obj?.strDate.split(separator: " ")
        if date!.count > 0{
            cell.lblDate.text = "Date: \(date?[0] ?? "")"
            cell.lblTime.text = "Time: \(date?[1] ?? "")"
        }
        
        cell.lblBidBy.text = "By:- \(obj?.strName ?? "")"
        cell.lblBidCount.text = "Bid : \(obj?.strBidsCount ?? "")"
                
        cell.btnThreeDot.tag = indexPath.row
        cell.btnThreeDot.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openActionSheet(sender: UIButton){
     
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
        
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBidViewController")as! AddBidViewController
                vc.strBidID = self.arrMyBidList[sender.tag].strBid_id
                vc.strSubCategoryID = self.strCategoryID
                vc.isComingFromEdit = true
                vc.objEditBidData = self.arrMyBidList[sender.tag]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                if self.myBidClicked == true{
                    self.call_DeleteBid(strBidID: self.arrMyBidList[sender.tag].strBid_id)
                }else{
                    self.call_DeleteBid(strBidID: self.arrBidList[sender.tag].strBid_id)
                }
            }))
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
               print("User click Dismiss button")
           }))
        
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        
        
        if self.myBidClicked == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubmittedBidsViewController")as! SubmittedBidsViewController
            vc.strBidId = self.arrMyBidList[indexPath.row].strBid_id
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailViewController")as! BidDetailViewController
            vc.objData = self.arrBidList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
                
                self.arrBidList.removeAll()
                self.arrMyBidList.removeAll()
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        
                        let obj = BidsListModel.init(dict: dictdata)
                        if obj.strUserIDBidPost == strUserID{
                            self.arrMyBidList.append(obj)
                        }else{
                            self.arrBidList.append(obj)
                        }
                        
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
    
    
    //================== Delete Bid =============//
    
    func call_DeleteBid(strBidID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
       
        var dicrParam = [String:Any]()
            dicrParam = ["bid_id":strBidID]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_PostDeleteBid, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                let userID = objAppShareData.UserDetail.strUserId
                self.call_getBids(strUserID: userID, strMyID: userID)
                
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
