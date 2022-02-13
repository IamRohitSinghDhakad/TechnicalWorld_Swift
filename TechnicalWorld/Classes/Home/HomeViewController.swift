//
//  HomeViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 11/04/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var cvCategories: UICollectionView!
    @IBOutlet weak var imgVwBanner: UIImageView!
    @IBOutlet weak var btnOpenMenu: UIButton!
    @IBOutlet var lblTitileOfferOne: UILabel!
    @IBOutlet var lblPriceOfferOne: UILabel!
    @IBOutlet var lblDescOfferOne: UILabel!
    @IBOutlet var lblOfferTwo: UILabel!
    @IBOutlet var lblPriceOfferTwo: UILabel!
    @IBOutlet var lblDescOffertwo: UILabel!
    @IBOutlet var lblOfferthree: UILabel!
    @IBOutlet var lblPriceOfferThree: UILabel!
    @IBOutlet var lblDescOfferThree: UILabel!
    @IBOutlet var tfSearchBar: UITextField!
    
    var arrCategory = [CategoryModel]()
    var arrCategoryFilter = [CategoryModel]()
    var arrOffer = [OfferModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_GetCategory()
        
        self.cvCategories.delegate = self
        self.cvCategories.dataSource = self
        
        self.tfSearchBar.delegate = self
        self.tfSearchBar.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        //Setup SideMenu
        if revealViewController() != nil {
            self.btnOpenMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer((revealViewController()?.tapGestureRecognizer())!)
        }
    }

    
    @IBAction func btnNotification(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")as! NotificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnProfile(_ sender: Any) {
        if objAppShareData.UserDetail.strUserId == ""{
            objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message: "Please Login/Register for profile", controller: self) {
                ObjAppdelegate.LoginNavigation()
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}




extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategoryFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)as? HomeCollectionViewCell{
            
           let objCategory = self.arrCategoryFilter[indexPath.row]
            
            cell.lblTitle.text = objCategory.strCategoryName.localized()
            
            let profilePic = objCategory.strCategoryImage
            
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgvwCategory.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let id = self.arrCategory[indexPath.row].strCategoryID
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactListViewController")as! ContactListViewController
            vc.strCategoryID = "\(id)"
            vc.strType = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.strTtitle = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.strTtitle = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.isComingfrom = "3"
            vc.strTtitle = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.strTtitle = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.strTtitle = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController")as! JobsViewController
            vc.categoryID = "\(id)"
//            vc.isComingfrom = "3"
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactListViewController")as! ContactListViewController
            vc.strCategoryID = "\(id)"
            vc.strType = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BidsViewController")as! BidsViewController
            vc.strCategoryID = "\(id)"
           // vc.strType = self.arrCategory[indexPath.row].strCategoryName
            self.navigationController?.pushViewController(vc, animated: true)
           // pushVc(viewConterlerId: "BidsViewController")
        default:
            pushVc(viewConterlerId: "DetailViewController")
        }
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     */
}

//MARK:- Searching
extension HomeViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
        self.arrCategoryFilter.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.arrCategory {
                let isMachingWorker : NSString = (dicData.strCategoryName) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    self.arrCategoryFilter.append(dicData)
                }
            }
        } else {
            self.arrCategoryFilter = self.arrCategory
        }
//        self.arrSubCategoryFiltered = self.arrSubCategoryFiltered.sorted(by: { $0.sort > $1.sort})
        self.cvCategories.reloadData()
    }
    
    
}

extension HomeViewController{
    
    func call_GetCategory(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getCategory, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.call_GetOffer()
                self.call_GetBanner()
              //  self.call_SubCategory()
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = CategoryModel.init(dict: dictdata)
                        self.arrCategory.append(obj)
                    }
                    
                    self.arrCategoryFilter = self.arrCategory
                    
                    self.cvCategories.reloadData()
                    
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
 
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
           // self.showAlerOnAppDelegate(strMessage: "No Internet Connection")
            return
        }
    
      //  objWebServiceManager.showIndicator()
        
       
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "Failed", title: "Alert", controller: self)
                }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }

    
   }
    
    
    
    //MARK:- Get Banner
    func call_GetOffer(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOffer, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
               
              //  self.call_SubCategory()
                
                if let arrData  = response["result"] as? [[String:Any]]{

                    for data in arrData{
                        
                        let obj = OfferModel.init(dict: data)
                        self.arrOffer.append(obj)
                        
                    }
                    
                    if self.arrOffer.count > 1{
                        
                        self.lblTitileOfferOne.text = self.arrOffer[0].strOfferTitle
                        self.lblPriceOfferOne.text = "Price: " + self.arrOffer[0].strPrice + " AED"
                        self.lblDescOfferOne.text = "By: " + self.arrOffer[0].strPostedBy
                        
                  
                        self.lblOfferTwo.text = self.arrOffer[1].strOfferTitle
                        self.lblPriceOfferTwo.text = "Price: " + self.arrOffer[1].strPrice + " AED"
                        self.lblDescOffertwo.text = "By: " + self.arrOffer[1].strPostedBy
                        
                    
                        self.lblOfferthree.text = self.arrOffer[2].strOfferTitle
                        self.lblPriceOfferThree.text = "Price: " + self.arrOffer[2].strPrice + " AED"
                        self.lblDescOfferThree.text = "By: " + self.arrOffer[2].strPostedBy
                    }
                    
                   
                    
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
    
    
    //Banner add ===================== XXXXX
    
    func call_GetBanner(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetSetting, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
               
              //  self.call_SubCategory()
                
                if let imgUrl  = response["result"] as? [String:Any]{

         
                    
                    if let profilePic = imgUrl["home_page_ads"]as? String{
                        if profilePic != "" {
                            let url = URL(string: profilePic.trim())
                            print(url)
                            self.imgVwBanner.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                        }
                    }
                    
                  
                   
                    
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
