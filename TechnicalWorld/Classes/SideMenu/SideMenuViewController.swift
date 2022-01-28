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
        if objAppShareData.UserDetail.strUserId == ""{
            titleName = ["Home","Add Post","Contact Us","About Us"]
        }else{
            titleName = ["Home","Add Post","Profile","Contact Us","About Us", "LogOut"]
        }
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if objAppShareData.UserDetail.strName != ""{
            self.lblUserName.text = objAppShareData.UserDetail.strName
        }else{
            self.lblUserName.text = "Guest User"
        }
       
        
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
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
        if objAppShareData.UserDetail.strUserId == ""{
            switch indexPath.row {
            case 0:
                pushVc(viewConterlerId: "Reveal")
                break
            case 1:
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message: "Please Login/Register for add any post", controller: self) {
                    ObjAppdelegate.LoginNavigation()
                }
               // pushVc(viewConterlerId: "AddJobViewController")
                break
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")as! AboutUsViewController
                vc.strIsComingFrom = "ContactUs"
                vc.strTitle = "ContactUs"
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")as! AboutUsViewController
                vc.strIsComingFrom = "AboutUs"
                vc.strTitle = "AboutUs"
                self.navigationController?.pushViewController(vc, animated: true)
                break
               default: break
                
            }
        }else{
            switch indexPath.row {
            case 0:
                pushVc(viewConterlerId: "Reveal")
               // ObjAppdelegate.HomeNavigation()
                break
            case 1:
                pushVc(viewConterlerId: "AddJobViewController")
               // pushVc(viewConterlerId: "Reveal")
                break
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
               // pushVc(viewConterlerId: "ProfileViewController")
                //break
            case 3:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")as! AboutUsViewController
                vc.strIsComingFrom = "ContactUs"
                vc.strTitle = "ContactUs"
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")as! AboutUsViewController
                vc.strIsComingFrom = "AboutUs"
                vc.strTitle = "AboutUs"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 5:
                ObjAppdelegate.LoginNavigation()
              //  self.LogoutDataAPI()
                break
            default: break
                
            }
        }

    }

    
}
