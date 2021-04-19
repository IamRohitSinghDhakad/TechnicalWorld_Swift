//
//  GiveReviesViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class GiveReviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        pushVc(viewConterlerId: "AddJobPostViewController")
    }
    
}
