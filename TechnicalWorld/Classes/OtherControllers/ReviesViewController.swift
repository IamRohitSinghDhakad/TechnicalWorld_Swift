//
//  ReviesViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class ReviesViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet var vwIndividual: UIView!
    @IBOutlet var vwCompany: UIView!
    @IBOutlet var vwContainerButtons: UIView!
    @IBOutlet var btnIndividual: UIButton!
    @IBOutlet var btnCompany: UIButton!
    
    var objUser:UserModel?
    var isType = ""
    
    var arrReviewIndividual = [ReviewModel]()
    var arrReviewCompany = [ReviewModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isType = "Individual"
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.call_GetReview(strReview: objUser?.strUserID ?? "0")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnGiveReview(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GiveReviesViewController")as! GiveReviesViewController
        vc.objUser = self.objUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnIndividual(_ sender: Any) {
        self.isType = "Individual"
        self.btnIndividual.backgroundColor = UIColor.init(named: "lightGreen")
        self.btnCompany.backgroundColor = UIColor.white
        self.tblVw.reloadData()
    }
    
    @IBAction func btnCompany(_ sender: Any) {
        self.isType = "Company"
        self.btnIndividual.backgroundColor = UIColor.white
        self.btnCompany.backgroundColor = UIColor.init(named: "lightGreen")
        self.tblVw.reloadData()
    }
    
    
    
    func call_GetReview(strReview:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["user_id":strReview]as [String:Any]
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetReview, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictdata in arrData{
                        
                        let obj = ReviewModel.init(dict: dictdata)
                        if obj.strSignup_as == "individual"{
                            self.arrReviewIndividual.append(obj)
                        }else{
                            self.arrReviewCompany.append(obj)
                        }
                       
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


extension ReviesViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isType == "Individual"{
            return self.arrReviewIndividual.count
        }else{
            return self.arrReviewCompany.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell")as! ReviewTableViewCell
        
        if self.isType == "Individual"{
            let obj = self.arrReviewIndividual[indexPath.row]
            
            cell.lblUserName.text = obj.strName
            cell.lblReviewText.text = obj.strReview
            cell.ratingVw.rating = obj.drating
            
            let profilePic = obj.strimage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }else{
            let obj = self.arrReviewCompany[indexPath.row]
            
            cell.lblUserName.text = obj.strName
            cell.lblReviewText.text = obj.strReview
            cell.ratingVw.rating = obj.drating
            
            let profilePic = obj.strimage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }
   
        
        return cell
    }
}
