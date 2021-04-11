//
//  SideMenuViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 11/04/21.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblSideMenuOptions: UITableView!
    
    var titleName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSideMenuOptions.delegate = self
        self.tblSideMenuOptions.dataSource = self
        titleName = ["Home","Add Post","Profile","Settings","Contact Us","About Us", "LogOut"]
        // Do any additional setup after loading the view.
    }

}


extension SideMenuViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return titleName.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.lblTitle.text = titleName[indexPath.row]
        return cell
    }
         
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushVc(viewConterlerId: "HomeViewController")
            break
        case 1:
            pushVc(viewConterlerId: "HomeViewController")
            break
        case 2:
            pushVc(viewConterlerId: "HomeViewController")
            break
        case 3:
            pushVc(viewConterlerId: "HomeViewController")
            break
        case 4:
            pushVc(viewConterlerId: "HomeViewController")
            break
            
        case 5:
            pushVc(viewConterlerId: "HomeViewController")
            break
        case 6:
          //  self.LogoutDataAPI()
            break
            
        default: break
            
        }
    }

    
}