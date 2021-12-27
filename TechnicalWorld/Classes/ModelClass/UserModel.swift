//
//  UserModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

class UserModel: NSObject {

    
    var strUserName :String = ""
    var strUserImage :String = ""
    var strUserCategory :String = ""
    var strUserSubCategory :String = ""
    var strUserID :String = ""
    var strPhoneNumber :String = ""
    var strLatitude :String = ""
    var strLongitude :String = ""
    var strDescription :String = ""
    var strPrice : String = ""
    var strRatingCompany : String = ""
    var strRatingIndividual : String = ""
    
    
    init(dict : [String:Any]) {
        
        if let username = dict["name"] as? String{
            self.strUserName = username
        }
        
        if let userID = dict["user_id"] as? String{
            self.strUserID = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUserID = "\(userID)"
        }
        
        if let phoneNumber = dict["mobile"] as? String{
            self.strPhoneNumber = phoneNumber
        }else if let phoneNumber = dict["mobile"] as? Int{
            self.strPhoneNumber = "\(phoneNumber)"
        }
        
        if let price = dict["price"] as? String{
            self.strPrice = price + "AED"
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)" + "AED"
        }
        
        if let userImage = dict["user_image"] as? String{
            self.strUserImage = userImage
        }
        
        if let catName = dict["category_name"] as? String{
            self.strUserCategory = catName
        }
        
        if let subCategoryName = dict["sub_category_name"] as? String{
            self.strUserSubCategory = subCategoryName
        }
        
        if let latitude = dict["lat"] as? String{
            self.strLatitude = latitude
        }
        
        if let longitude = dict["lon"] as? String{
            self.strLongitude = longitude
        }
        
        if let description = dict["description"] as? String{
            self.strDescription = description
        }
        
        if let rating_company = dict["rating_company"] as? String{
            self.strRatingCompany = rating_company
        }
        
        if let rating_individual = dict["rating_individual"] as? String{
            self.strRatingIndividual = rating_individual
        }
        
        
        
        
    }
}
