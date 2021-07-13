//
//  AddJobViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 02/05/21.
//

import UIKit

class AddJobViewController: UIViewController {

    
    @IBOutlet var vwJobs: UIView!
    @IBOutlet var vwRealState: UIView!
    
    var isSelected = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwRealState.borderColor = UIColor.lightGray
        self.vwJobs.borderColor = UIColor.lightGray
    }
    

    @IBAction func btnRealState(_ sender: Any) {
        self.isSelected = "RealState"
        self.vwRealState.borderColor = UIColor.init(named: "darkGreen")
        self.vwJobs.borderColor = UIColor.lightGray
    }
    @IBAction func btnJobs(_ sender: Any) {
        self.isSelected = "Jobs"
        self.vwRealState.borderColor = UIColor.lightGray
        self.vwJobs.borderColor = UIColor.init(named: "darkGreen")
    }
    
    @IBAction func btnOnNext(_ sender: Any) {
        if isSelected == "RealState"{
            self.pushVc(viewConterlerId: "AddPostViewController")
        }else{
            self.pushVc(viewConterlerId: "AddJobPostViewController")
        }
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
}
