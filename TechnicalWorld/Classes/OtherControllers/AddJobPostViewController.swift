//
//  AddJobPostViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class AddJobPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnWantAJob(_ sender: Any) {
    }
    
    @IBAction func btnOnOfferAJob(_ sender: Any) {
        pushVc(viewConterlerId: "OfferJobViewController")
        
    }
    @IBAction func btnOnNext(_ sender: Any) {
        pushVc(viewConterlerId: "WantJobViewController")
        
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
