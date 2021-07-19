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
    
    
    init(dict : [String:Any]) {
        
        if let image = dict["image"] as? String{
            self.strImageUrl = image
        }
        
        if let description = dict["description"] as? String{
            self.strTitle = description
        }
        
        if let entrydt = dict["entrydt"] as? String{
            self.strDate = entrydt
        }
        
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let bids = dict["bids"] as? String{
            self.strBidsCount = bids
        }else if let bids = dict["bids"] as? Int{
            self.strBidsCount = "\(bids)"
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
