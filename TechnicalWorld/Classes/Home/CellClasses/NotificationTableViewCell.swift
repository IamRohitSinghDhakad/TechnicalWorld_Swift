//
//  NotificationTableViewCell.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/11/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var imgvw: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
