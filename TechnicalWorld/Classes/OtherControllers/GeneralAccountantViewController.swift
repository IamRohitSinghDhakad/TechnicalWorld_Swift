//
//  GeneralAccountantViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class GeneralAccountantViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet var lblTitleCategory: UILabel!
    @IBOutlet var lblCareerLevel: UILabel!
    @IBOutlet var lblEmployementType: UILabel!
    @IBOutlet var lblMinimumWorkExp: UILabel!
    @IBOutlet var lblEducationLvl: UILabel!
    @IBOutlet var lblCompanySide: UILabel!
    @IBOutlet var lblPostedOn: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDescHeading: UILabel!
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var lblRevieCountCompany: UILabel!
    @IBOutlet var lblIndividual: UILabel!
    @IBOutlet var lblReviewCountIndividual: UILabel!
    
    var objUser:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objUser?.strPostFor == "Full Time"{
            self.lblDescHeading.isHidden = true
            self.lblDescription.isHidden = true
        }else{
            self.lblDescHeading.isHidden = false
            self.lblDescription.isHidden = false
            
            self.lblDescription.text = objUser?.strRemark
        }
        
        let profilePic = objUser?.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.lblTitle.text = objUser?.strUserName
        self.lblTitleCategory.text = objUser?.strOfferDesc
        self.lblCareerLevel.text = objUser?.strUserSubCategory
        self.lblEmployementType.text = objUser?.strPostFor
        self.lblMinimumWorkExp.text = "\(objUser?.strExperience ?? "") Years"//objUser?.strExperience ?? "0" + " Years"
        self.lblEducationLvl.text = objUser?.strDegree
        self.lblPostedOn.text = objUser?.strDate
        
        self.lblCompany.text = "Companies : \(objUser?.strRatingCompany ?? "")"
        self.lblIndividual.text = "Individual : \(objUser?.strRatingIndividual ?? "")"
        
        self.lblRevieCountCompany.text = "(\(objUser?.strReviewCompany ?? ""))"
        self.lblReviewCountIndividual.text = "(\(objUser?.strReviewIndividual ?? ""))"

    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOpenWhasApp(_ sender: Any) {
        self.openWhatsApp(strPhoneNumber: objUser!.strPhoneNumber)
    }
    @IBAction func btnOpenCall(_ sender: Any) {
        self.callNumber(phoneNumber: objUser!.strPhoneNumber)
    }
    
    @IBAction func btnOpenLocation(_ sender: Any) {
        
    }
    @IBAction func btnHome(_ sender: Any) {
        self.pushVc(viewConterlerId: "Reveal")
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
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
   

}
