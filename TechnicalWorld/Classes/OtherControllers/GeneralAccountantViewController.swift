//
//  GeneralAccountantViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class GeneralAccountantViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet var lblTitleCategory: UILabel!
    @IBOutlet var lblCareerLevel: UILabel!
    @IBOutlet var lblEmployementType: UILabel!
    @IBOutlet var lblMinimumWorkExp: UILabel!
    @IBOutlet var lblEducationLvl: UILabel!
    @IBOutlet var lblCompanySide: UILabel!
    @IBOutlet var lblPostedOn: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOpenWhasApp(_ sender: Any) {
        
    }
    @IBAction func btnOpenCall(_ sender: Any) {
        
    }
    @IBAction func btnOpenLocation(_ sender: Any) {
        
    }
    /*
     @IBAction func btnHomeAction(_ sender: Any) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
