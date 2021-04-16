//
//  RentDetailViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class RentDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHome(_ sender: Any) {
        
    }
    
    @IBAction func btnOpenWhatsapp(_ sender: Any) {
        
    }
    
    @IBAction func btnOpenCall(_ sender: Any) {
    }
    
    @IBAction func btnOpenLocation(_ sender: Any) {
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
