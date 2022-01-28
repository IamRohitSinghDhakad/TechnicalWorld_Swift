//
//  AboutUsViewController.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/11/21.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var lblTitile: UILabel!
    
    var strIsComingFrom = ""
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch strTitle {
        case "AboutUs":
            self.lblTitile.text = "About Us"
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/About%20Us")
        case "FAQ":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/FAQ")
        case "Privacy":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/Privacy")
        case "Terms":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/Terms")
        case "ContactUs":
            self.lblTitile.text = "Contact Us"
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/Contact%20Us")
        default:
            break
        }
        
       
        
    }
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        DispatchQueue.main.async {
            self.webVw.load(request as URLRequest)
        }
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
}
