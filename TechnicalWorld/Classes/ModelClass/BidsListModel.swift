//
//  BidsListModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 18/07/21.
//

import UIKit

class BidsListModel: NSObject {

    var strImageUrl :String = ""
    var strName :String = ""
    var strBid_id :String = ""
    var strTitle : String = ""
    var strDate : String = ""
    var strBidsCount : String = ""
    var strDuration : String = ""
    var strSubmittedOffered : String = ""
    var strCategoryName : String = ""
    var strUserImage : String = ""
    var strSubCategoryID : String = ""
    var strSubCategoryName : String = ""
    var strUserIDBidPost:String = ""
    var strCategoryID:String = ""
    
    
    init(dict : [String:Any]) {
        
        if let image = dict["image"] as? String{
            self.strImageUrl = image
        }
        
        if let category_name = dict["category_name"] as? String{
            self.strCategoryName = category_name
        }
        
        if let description = dict["description"] as? String{
            self.strTitle = description
        }
        
        if let entrydt = dict["entrydt"] as? String{
            self.strDate = entrydt
        }
        
        //=========== XX =============//
        if let strCategoryID = dict["category_id"] as? String{
            self.strCategoryID = strCategoryID
        }else  if let strCategoryID = dict["category_id"] as? Int{
            self.strCategoryID = "\(strCategoryID)"
        }
        
        
        if let sub_category_id = dict["sub_category_id"] as? String{
            self.strSubCategoryID = sub_category_id
        }else  if let sub_category_id = dict["sub_category_id"] as? Int{
            self.strSubCategoryID = "\(sub_category_id)"
        }
        
        if let sub_category_name = dict["sub_category_name"] as? String{
            self.strSubCategoryName = sub_category_name
        }else  if let sub_category_name = dict["sub_category_name"] as? Int{
            self.strSubCategoryName = "\(sub_category_name)"
        }
        //=========== XX =============//
        
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let bids = dict["bids"] as? String{
            self.strBidsCount = bids
        }else if let bids = dict["bids"] as? Int{
            self.strBidsCount = "\(bids)"
        }
        
        
        if let user_id = dict["bid_id"] as? String{
            self.strBid_id = user_id
        }else if let user_id = dict["bid_id"] as? Int{
            self.strBid_id = "\(user_id)"
        }
        
        
        if let user_id = dict["user_id"] as? String{
            self.strUserIDBidPost = user_id
        }else if let user_id = dict["user_id"] as? Int{
            self.strUserIDBidPost = "\(user_id)"
        }
        
        
        if let duration = dict["duration"] as? String{
            self.strDuration = duration
        }else if let duration = dict["duration"] as? Int{
            self.strDuration = "\(duration)"
        }
        
        if let offered = dict["offered"] as? String{
            self.strSubmittedOffered = offered
        }else if let offered = dict["offered"] as? Int{
            self.strSubmittedOffered = "\(offered)"
        }
    }

}
