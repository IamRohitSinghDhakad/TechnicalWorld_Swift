//
//  NotificationModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/11/21.
//

import UIKit

class NotificationModel: NSObject {
    
    
    var strNotificationTitle : String = ""
    var strNotification_id : String = ""
    var strimage : String = ""
    var strNotification : String = ""
    var strTimeAGO : String = ""
    
    
    init(dict : [String:Any]) {
        
        if let image = dict["image"] as? String{
            self.strimage = image
        }
        
        if let notification = dict["notification"] as? String{
            self.strNotification = notification
        }
        
        if let notification_title = dict["notification_title"] as? String{
            self.strNotificationTitle = notification_title
        }
        
        if let timeAgo = dict["time_ago"]as? String{
            self.strTimeAGO = timeAgo
        }
    }

}
