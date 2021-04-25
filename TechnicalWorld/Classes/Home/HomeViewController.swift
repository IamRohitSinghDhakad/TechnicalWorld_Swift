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
    
    var arrCategory = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_GetCategory()
//        let userID = objAppShareData.UserDetail.strUserId
//       if userID != ""{
//        self.call_GetProfile(strUserID: userID)
//       }
       
        
//        self.arrTitles = ["Consultants","Contractors","Suppliers","Real State","Services","Maintenance", "Jobs", "Lawyer and \n Arbitrations", "Bids"]
//        self.arrImages = [#imageLiteral(resourceName: "consultants"),#imageLiteral(resourceName: "contractors"),#imageLiteral(resourceName: "suppliers"),#imageLiteral(resourceName: "real"),#imageLiteral(resourceName: "service"),#imageLiteral(resourceName: "main"),#imageLiteral(resourceName: "jobs"),#imageLiteral(resourceName: "lawyer"),#imageLiteral(resourceName: "bids")]
        
        self.cvCategories.delegate = self
        self.cvCategories.dataSource = self
        
        //Setup SideMenu
        if revealViewController() != nil {
            self.btnOpenMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer((revealViewController()?.tapGestureRecognizer())!)
        }
    }

}




extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)as? HomeCollectionViewCell{
            
           let objCategory = self.arrCategory[indexPath.row]
            
            cell.lblTitle.text = objCategory.strCategoryName
            
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
          //  pushVc(viewConterlerId: "ContactListViewController")
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.isComingfrom = "3"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
            vc.categoryID = "\(id)"
            vc.isComingfrom = "3"
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            pushVc(viewConterlerId: "GiveReviesViewController")
        case 8:
            pushVc(viewConterlerId: "BidsViewController")
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
               
              //  self.call_SubCategory()
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = CategoryModel.init(dict: dictdata)
                        self.arrCategory.append(obj)
                    }
                    
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
    
}
