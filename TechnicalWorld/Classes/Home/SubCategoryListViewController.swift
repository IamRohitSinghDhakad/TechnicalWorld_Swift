//
//  SubCategoryListViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class SubCategoryListViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var vwRentBuy: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwSearchBar.isHidden = false
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
    }
}


extension SubCategoryListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell")as! SubCategoryTableViewCell
        
        return cell
    }
    
    
}
