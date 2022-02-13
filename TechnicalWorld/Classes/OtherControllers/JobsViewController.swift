//
//  JobsViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 16/05/21.
//

import UIKit

class JobsViewController: UIViewController {

    @IBOutlet var lblJobsTitile: UILabel!
    @IBOutlet var btnFullTime: UIButton!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwPartTime: UIView!
    @IBOutlet var vwFulltime: UIView!
    @IBOutlet var btnPartTime: UIButton!
    
    
    var categoryID = ""
    var strSubCategoryID = ""
    var strType = ""
    var strPostFor = ""
    var arrJobs = ["Vacancies".localized(), "Searching for a job".localized()]
   // var arrDetailsSubcategory = [DetailsSubCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.strType = "Full Time"
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOnFullTime(_ sender: Any) {
        self.strType = "Full Time".localized()
        self.vwFulltime.backgroundColor = UIColor.init(named: "lightGreen")
        self.vwPartTime.backgroundColor = UIColor.white
    }
    
    
    @IBAction func btnOnPartTime(_ sender: Any) {
        self.strType = "Part Time".localized()
        self.vwFulltime.backgroundColor = UIColor.white
        self.vwPartTime.backgroundColor = UIColor.init(named: "lightGreen")
    }
}

extension JobsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell")as! SubCategoryTableViewCell
        
        cell.lblSubCategory.text = self.arrJobs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController")as! SubCategoryListViewController
        
        if self.strType == "Full Time" {
            vc.strPostFor = "Full Time"
            if self.arrJobs[indexPath.row] == "Vacancies"{
                vc.strTtitle = "Full Time Vacancies"
                vc.isComingfrom = self.categoryID
                vc.isType = "Offer"
            }else{
                vc.strTtitle = "Full Time Jobs"
                vc.isComingfrom = self.categoryID
                vc.isType = "Want"
            }
        }else{
            vc.strPostFor = "Part Time"
            if self.arrJobs[indexPath.row] == "Vacancies"{
                vc.strTtitle = "Part Time Vacancies"
                vc.isComingfrom = self.categoryID
                vc.isType = "Offer"
            }else{
                vc.strTtitle = "Part Time Jobs"
                vc.isComingfrom = self.categoryID
                vc.isType = "Want"
            }
        }
        vc.categoryID = self.categoryID
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

