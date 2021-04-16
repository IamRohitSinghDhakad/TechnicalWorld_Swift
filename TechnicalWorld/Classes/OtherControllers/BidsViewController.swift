//
//  BidsViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 14/04/21.
//

import UIKit

class BidsViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        
    }
    @IBAction func btnAllBids(_ sender: Any) {
        
    }
    @IBAction func btnMyBids(_ sender: Any) {
        
    }
   
}

extension BidsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidsTableViewCell")as! BidsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "BidDetailViewController")
    }
    
    
    
}
