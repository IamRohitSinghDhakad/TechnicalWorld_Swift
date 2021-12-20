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
    
    var strIsComingFrom = ""
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch strTitle {
        case "AboutUs":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/AboutUs")
        case "FAQ":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/FAQ")
        case "Privacy":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/Privacy")
        case "Terms":
            self.loadUrl(strUrl: "https://technicalworld.ae/admin/index.php/api/page/Terms")
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
