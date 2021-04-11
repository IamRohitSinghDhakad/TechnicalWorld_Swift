//
//  LoginViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnContinue(_ sender: Any) {
        
        ObjAppdelegate.HomeNavigation()
       // self.pushVc(viewConterlerId: "Reveal")
        
    }
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        
    }
    @IBAction func btnOnRegisterNow(_ sender: Any) {
    }
    @IBAction func btnFacebookLogin(_ sender: Any) {
        
    }
    @IBAction func btnGoogleLogin(_ sender: Any) {
    }
    @IBOutlet weak var btnOnAppleLogin: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
