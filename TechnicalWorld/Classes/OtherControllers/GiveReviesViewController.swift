//
//  GiveReviesViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class GiveReviesViewController: UIViewController,FloatRatingViewDelegate {

    
    var objUser:UserModel?
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblHowWas: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var txtVwReview: RDTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.ratingView.emptyImage = ima
        
        let profilePic = objUser?.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.lblUserName.text = objUser?.strUserName
        self.lblHowWas.text = "How was the experience with \(objUser?.strUserName ?? "")"
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        pushVc(viewConterlerId: "AddJobPostViewController")
    }
    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print(rating)
        
        
    }
}
