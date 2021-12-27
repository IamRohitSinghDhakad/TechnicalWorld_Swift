//
//  SubmittedBidsUsersViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 24/12/21.
//

import UIKit

class SubmittedBidsUsersViewController: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblRatingCompany: UILabel!
    @IBOutlet var lblRatingIndividual: UILabel!
    
    var objUser:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
    }
    
    func setData(){
        self.lblTitle.text = objUser?.strUserName
        self.lblDescription.text = objUser?.strDescription
        self.lblPrice.text = objUser?.strPrice
        self.lblCategory.text = objUser?.strUserCategory
        self.lblRatingCompany.text = objUser?.strRatingCompany
        self.lblRatingIndividual.text = objUser?.strRatingIndividual
        
        let profilePic = objUser?.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
    }
    
    @IBAction func btnCalls(_ sender: Any) {
        guard let number = objUser?.strPhoneNumber else { return }
        let name = objUser?.strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to call \(String(describing: name)) ?", controller: self) {
            self.callNumber(phoneNumber: number)
        }
    }
    
    @IBAction func btnWhatsapp(_ sender: Any) {
        guard let number = objUser?.strPhoneNumber else { return  }
        let name = objUser?.strUserName
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Are you sure to chat with \(name ?? "") on whatsapp?", controller: self) {
            self.openWhatsApp(strPhoneNumber: number)
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }

    
    @IBAction func btnReview(_ sender: Any) {
      //  pushVc(viewConterlerId: "ReviesViewController")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviesViewController")as! ReviesViewController
        vc.objUser = self.objUser
        self.navigationController?.pushViewController(vc, animated: true)
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
}
