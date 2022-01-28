//
//  RentDetailViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class RentDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblCompanyRating: UILabel!
    @IBOutlet var lblIndividualRating: UILabel!
    @IBOutlet var lblTitleCategory: UILabel!
    @IBOutlet var cvImages: UICollectionView!
    @IBOutlet var pgControl: UIPageControl!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblBedroom: UILabel!
    @IBOutlet var lblBathroom: UILabel!
    @IBOutlet var lblFurnish: UILabel!
    @IBOutlet var lblListedBy: UILabel!
    @IBOutlet var lblSuperBuiltUp: UILabel!
    @IBOutlet var lblCarpertArea: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    var objDetails:DetailsSubCategoryModel?
    var thisWidth:CGFloat = 0
    var arrImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserData()
        
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        
        thisWidth = CGFloat(self.cvImages.frame.width)
        pgControl.hidesForSinglePage = true
    }
    
    
    func setUserData(){

        if objDetails?.strImageURL1 != ""{
            let url = objDetails!.strBaseUrl + objDetails!.strImageURL1
            self.arrImages.append(url)
        }
        if objDetails?.strImageURL2 != ""{
            let url = objDetails!.strBaseUrl + objDetails!.strImageURL2
            self.arrImages.append(url)
        }
        if objDetails?.strImageURL3 != ""{
            let url = objDetails!.strBaseUrl + objDetails!.strImageURL3
            self.arrImages.append(url)
        }
        
        self.cvImages.reloadData()
        
        let profilePic = self.objDetails?.strImageUrl
        
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        self.lblTitle.text = objDetails?.strName
        self.lblTitleCategory.text = "Property " + objDetails!.strListedBy
        self.lblPrice.text = objDetails!.strPrice + " AED"
        self.lblDescription.text = objDetails?.strHeading
        self.lblType.text = objDetails?.strSubCategory
        self.lblBedroom.text = objDetails?.strRoom
        self.lblBathroom.text = objDetails?.strToilet
        self.lblFurnish.text = objDetails?.strFurnishedStatus
        self.lblListedBy.text = objDetails?.strListedBy
        self.lblSuperBuiltUp.text = objDetails?.strSize
        self.lblDesc .text = objDetails?.strDetail
    }
    
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.pushVc(viewConterlerId: "Reveal")
    }
    
    @IBAction func btnOpenWhatsapp(_ sender: Any) {
        self.openWhatsApp(strPhoneNumber: objDetails!.strMobile)
    }
    
    @IBAction func btnOpenCall(_ sender: Any) {
        self.callNumber(phoneNumber: objDetails!.strMobile)
    }
    
    @IBAction func btnOpenLocation(_ sender: Any) {
        self.openMaps(latitude: Double(objDetails!.strLatitude) ?? 0.0, longitude: Double(objDetails!.strLongitude) ?? 0.0, title: "Location")
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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

extension RentDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentDetailCollectionViewCell", for: indexPath)as! RentDetailCollectionViewCell
        
        let obj = self.arrImages[indexPath.row]
        
        let profilePic = obj
        
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 1

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pgControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

}


extension UIImageView {
  public func maskCircle(anyImage: UIImage) {
    self.contentMode = UIView.ContentMode.scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true

   // make square(* must to make circle),
   // resize(reduce the kilobyte) and
   // fix rotation.
   self.image = anyImage
  }
}
