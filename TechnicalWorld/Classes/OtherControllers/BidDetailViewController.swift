//
//  BidDetailViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 14/04/21.
//

import UIKit

class BidDetailViewController: UIViewController {

    var objData : BidsListModel?
    @IBOutlet var imgVwBid: UIImageView!
    @IBOutlet var timeRemaning: UILabel!
    @IBOutlet var lblSubmittedOffer: UILabel!
    @IBOutlet var lblBidBy: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setData()
        // Do any additional setup after loading the view.
    }
    
    
    func setData(){
        
        let profilePic = objData?.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic!)
            self.imgVwBid.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.timeRemaning.text = "Days remaning - \(objData?.strDuration ?? "")"
        self.lblDescription.text = objData?.strTitle
        self.lblSubmittedOffer.text = objData?.strSubmittedOffered
        self.lblBidBy.text = objData?.strName
     
        
        
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnSubmittedOffer(_ sender: Any) {
        pushVc(viewConterlerId: "SubmitOfferViewController")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
