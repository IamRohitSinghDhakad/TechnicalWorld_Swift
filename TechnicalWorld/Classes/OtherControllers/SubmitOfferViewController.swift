//
//  SubmitOfferViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 16/04/21.
//

import UIKit
import SDWebImage

class SubmitOfferViewController: UIViewController {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtVw: RDTextView!
    @IBOutlet weak var tfPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setData()
        
        // Do any additional setup after loading the view.
    }
    
    func setData(){
        
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
      
        self.lblUserName.text = objAppShareData.UserDetail.strName
        self.lblEmail.text = objAppShareData.UserDetail.strEmail
        self.lblCategory.text = objAppShareData.UserDetail.strCategory
        
     
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnContinue(_ sender: Any) {
        pushVc(viewConterlerId: "AddBidViewController")
    }
  

}
