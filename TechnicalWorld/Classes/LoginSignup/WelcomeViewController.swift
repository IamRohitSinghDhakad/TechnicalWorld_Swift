//
//  WelcomeViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var cvPageControlSlide: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var arrBanners = [WelcomeModel]()
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvPageControlSlide.delegate = self
        self.cvPageControlSlide.dataSource = self

     
    
        self.call_GetBanner()
    }
    
    
    @objc func changeImage() {
     
     if counter < arrBanners.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.cvPageControlSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageController.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.cvPageControlSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageController.currentPage = counter
         counter = 1
     }
         
     }
    
    @IBAction func btnOnGetStarted(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrBanners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCollectionViewCell", for: indexPath)as! WelcomeCollectionViewCell
        
        let obj = self.arrBanners[indexPath.row]
        
        cell.lblTitle.text = obj.strBanner_name
        
           let profilePic = obj.strBanner_image
            if profilePic != "" {
                let url = URL(string: profilePic.trim())
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
             }

        return cell
    }
}

extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cvPageControlSlide.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


extension WelcomeViewController{
    
    //Banner add ===================== XXXXX
    
    func call_GetBanner(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetBanner, params: [:], queryParams: [:], strCustomValidation: "") { [self] (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
          
            
            if status == MessageConstant.k_StatusCode{
               
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{

                        let obj = WelcomeModel.init(dict: dictdata)
                        self.arrBanners.append(obj)
                    }
                    self.cvPageControlSlide.reloadData()
                    
                    // Do any additional setup after loading the view.
                    pageController.numberOfPages = self.arrBanners.count
                    pageController.currentPage = 0
                    
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
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
