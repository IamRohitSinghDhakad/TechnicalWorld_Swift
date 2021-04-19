//
//  ReviesViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 18/04/21.
//

import UIKit

class ReviesViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
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
