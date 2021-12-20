//
//  WelcomeModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 08/12/21.
//

import UIKit

class WelcomeModel: NSObject {
    
    var strBanner_image :String = ""
    var strBanner_name :String = ""
    var strbanner_id:String = ""
    
    
    init(dict : [String:Any]) {
        
        if let banner_name = dict["banner_name"] as? String{
            self.strBanner_name = banner_name
        }
        
        if let banner_image = dict["banner_image"] as? String{
            self.strBanner_image = banner_image
        }
    }
}
