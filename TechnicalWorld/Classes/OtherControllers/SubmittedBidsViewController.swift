//
//  SubmittedBidsViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Dhakad on 23/12/21.
//

import UIKit

class SubmittedBidsViewController: UIViewController {

    @IBOutlet var tblUsers: UITableView!
    
    var arrUsers = [BidsListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblUsers.delegate = self
        self.tblUsers.dataSource = self
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
   
}


extension SubmittedBidsViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmittedTableViewCell")as! SubmittedTableViewCell
        
        
        
        return cell
    }
    
    
    
    
}
