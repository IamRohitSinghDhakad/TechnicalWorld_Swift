//
//  OfferJobViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class OfferJobViewController: UIViewController {
    
    @IBOutlet var tfOfferDesc: UITextField!
    @IBOutlet var txtVwWriteHere: RDTextView!
    @IBOutlet var tfMinimumQualification: UITextField!
    @IBOutlet var tfField: UITextField!
    @IBOutlet var tfMinimumYear: UITextField!
    @IBOutlet var tfOfferRole: UITextField!
    @IBOutlet var lblOfferedText: UILabel!
    @IBOutlet var tfPackage: UITextField!
    @IBOutlet var imgVwFullTime: UIImageView!
    @IBOutlet var imgVwPartTime: UIImageView!
    @IBOutlet var vwOtherBenifits: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblOfferedText.text = "Offered Package"
        self.vwOtherBenifits.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnFullTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "radio")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "circle")
        
        self.lblOfferedText.text = "Offered Package"
        self.vwOtherBenifits.isHidden = true
    }
    
    @IBAction func btnOnpartTime(_ sender: Any) {
        self.imgVwFullTime.image = #imageLiteral(resourceName: "circle")
        self.imgVwPartTime.image = #imageLiteral(resourceName: "radio")
        
        self.lblOfferedText.text = "Offered Salary"
        self.vwOtherBenifits.isHidden = false
    }
    
    @IBAction func btnOnPost(_ sender: Any) {
        
    }

}


