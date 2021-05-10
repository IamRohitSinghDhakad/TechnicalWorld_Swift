//
//  AddJobPostViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class AddJobPostViewController: UIViewController {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vwFirst: UIView!
    @IBOutlet var vwSecond: UIView!
    @IBOutlet var btnWantJobRealState: UIButton!
    @IBOutlet var btnOfferAJob: UIButton!
    
    var isSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwFirst.borderColor = UIColor.lightGray
        self.vwSecond.borderColor = UIColor.lightGray
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnWantAJob(_ sender: Any) {
        self.isSelected = "WantAJob"
        self.vwFirst.borderColor = UIColor.init(named: "darkGreen")
        self.vwSecond.borderColor = UIColor.lightGray
    }
    
    @IBAction func btnOnOfferAJob(_ sender: Any) {
        self.isSelected = "OfferAJob"
        self.vwSecond.borderColor = UIColor.init(named: "darkGreen")
        self.vwFirst.borderColor = UIColor.lightGray
    }
    
    @IBAction func btnOnNext(_ sender: Any) {
        if isSelected == "WantAJob"{
            pushVc(viewConterlerId: "WantJobViewController")
        }else{
            pushVc(viewConterlerId: "OfferJobViewController")
        }
    }
}
