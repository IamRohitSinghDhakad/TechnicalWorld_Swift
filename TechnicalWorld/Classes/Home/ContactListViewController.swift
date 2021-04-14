//
//  ContactListViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class ContactListViewController: UIViewController {

    @IBOutlet weak var subVwSort: UIView!
    @IBOutlet weak var tblVwContacts: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVwContacts.delegate = self
        self.tblVwContacts.dataSource = self
        
        self.subVwSort.isHidden = true
        
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
        
    }
    @IBAction func btnOnCamcelSubVw(_ sender: Any) {
        self.subVwSort.isHidden = true
    }
    
    @IBAction func btnOnLocation(_ sender: Any) {
        
    }
    @IBAction func btnOnSort(_ sender: Any) {
        self.subVwSort.isHidden = false
        
    }
    
    @IBAction func btnActionSortData(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("high to low")
        case 1:
            print("low to high")
        case 2:
            print("high to low Individual")
        case 3:
            print("low to High Individual")
        default:
            break
        }
    }
    
}


extension ContactListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell")as! ContactListTableViewCell
        
        
        
        return cell
    }
    
    
    
    
}
