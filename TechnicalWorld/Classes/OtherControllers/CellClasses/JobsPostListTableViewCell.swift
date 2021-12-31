//
//  JobsPostListTableViewCell.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 31/12/21.
//

import UIKit

class JobsPostListTableViewCell: UITableViewCell {

    @IBOutlet var vwUserImage: UIView!
    @IBOutlet var vwCallingButtons: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblField: UILabel!
    @IBOutlet var lblDegree: UILabel!
    @IBOutlet var lblExperience: UILabel!
    @IBOutlet var lblJobtype: UILabel!
    @IBOutlet var lblAED: UILabel!
    @IBOutlet var btnWhatsapp: UIButton!
    @IBOutlet var btnCall: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
