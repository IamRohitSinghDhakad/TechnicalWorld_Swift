//
//  RentViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class RentViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var vwBtns: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwSearchBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }

}

extension RentViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentTableViewCell")as! RentTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "RentDetailViewController")
    }
    
    
}
