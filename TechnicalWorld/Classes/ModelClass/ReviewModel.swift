//
//  ReviewModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 26/12/21.
//

import UIKit

class ReviewModel: NSObject {
    
    var strName :String = ""
    var strReview :String = ""
    var strSignup_as :String = ""
    var strimage :String = ""
    var drating :Double = 0.0
    var strRating :String = ""
    
    
    init(dict : [String:Any]) {
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let review = dict["review"] as? String{
            self.strReview = review
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strimage = user_image
        }
        
        if let signup_as = dict["signup_as"] as? String{
            self.strSignup_as = signup_as
        }
        
        
        if let rating = dict["rating"] as? Double{
            self.drating = rating
        }else  if let rating = dict["rating"] as? String{
            self.drating = Double(rating) ?? 0.0
        }
        
        
//        if let rating_by = dict["rating_by"] as? Double{
//            self.drating = rating_by
//        }else  if let rating_by = dict["rating_by"] as? String{
//            self.drating = Double(rating_by) ?? 0.0
//        }
        
        
        
        
        
        
    }
}
