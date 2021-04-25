//
//  DetailViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var cvPictures: UICollectionView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var lblService: UILabel!
    
    var arrImages = [ServiceImagesModel]()
    var objUser = UserModel(dict: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvPictures.delegate = self
        self.cvPictures.dataSource = self
        
        let userID = objAppShareData.UserDetail.strUserId
        if userID != ""{
            self.call_UserImage(strUserID: userID, strLoginID: objUser.strUserID)
        }
        self.setUserData()
    }
    
    func setUserData(){
        self.lblHeader.text = objUser.strUserName
        self.lblService.text = objUser.strUserSubCategory + " \(objUser.strUserCategory)"
        let profilePic = objUser.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwCategory.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
    }
    
    @IBAction func btnOnHome(_ sender: Any) {
        
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOpenWhatsapp(_ sender: Any) {
        self.openWhatsApp(strPhoneNumber: objUser.strPhoneNumber)
    }
    
    @IBAction func btnOnCallAction(_ sender: Any) {
        self.callNumber(phoneNumber: objUser.strPhoneNumber )
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func btnOnLocation(_ sender: Any) {
        
        self.openMaps(latitude: Double(objUser.strLatitude) ?? 0.0, longitude: Double(objUser.strLongitude) ?? 0.0, title: "Location")
        
       // self.pushVc(viewConterlerId: "MapViewViewController")
    }
    
    func openWhatsApp(strPhoneNumber:String){
        let phoneNumber =  strPhoneNumber // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            let appURLL = URL(string: "https://wa.me/\(strPhoneNumber)")!
            if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURLL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURLL)
                }
        }
    }
    
    func openMaps(latitude: Double, longitude: Double, title: String?) {
        let application = UIApplication.shared
        let coordinate = "\(latitude),\(longitude)"
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let handlers = [
            ("Apple Maps", "http://maps.apple.com/?q=\(encodedTitle)&ll=\(coordinate)"),
            ("Google Maps", "comgooglemaps://?q=\(coordinate)"),
            ("Waze", "waze://?ll=\(coordinate)"),
            ("Citymapper", "citymapper://directions?endcoord=\(coordinate)&endname=\(encodedTitle)")
        ]
            .compactMap { (name, address) in URL(string: address).map { (name, $0) } }
            .filter { (_, url) in application.canOpenURL(url) }

        guard handlers.count > 1 else {
            if let (_, url) = handlers.first {
                application.open(url, options: [:])
            }
            return
        }
        let alert = UIAlertController(title: "Select Map", message: nil, preferredStyle: .actionSheet)
        handlers.forEach { (name, url) in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                application.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "Choose", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension DetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath)as? DetailCollectionViewCell{
            let obj = self.arrImages[indexPath.row]
            let profilePic = obj.strImageUrl
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = self.arrImages[indexPath.row].strImageUrl
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageViewController")as! ShowImageViewController
        vc.imageUrl = url
        self.navigationController?.pushViewController(vc, animated: true)
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


extension DetailViewController{
    //http://ambitious.in.net/Shubham/tech/index.php/api/get_user_image?user_id=7&login_id=7
    
    func call_UserImage(strUserID:String,strLoginID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       objWebServiceManager.showIndicator()
        let param = ["login_id":strLoginID,
                     "user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                print(response)
               
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{

                        let obj = ServiceImagesModel.init(dict: dictdata)
                        self.arrImages.append(obj)
                    }
                    self.cvPictures.reloadData()
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


