//
//  SubmitOfferViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 16/04/21.
//

import UIKit

class SubmitOfferViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnContinue(_ sender: Any) {
        pushVc(viewConterlerId: "AddBidViewController")
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
