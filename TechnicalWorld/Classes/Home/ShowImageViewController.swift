//
//  ShowImageViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profilePic = imageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
}
