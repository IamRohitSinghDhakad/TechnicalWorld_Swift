//
//  SubmittedTableViewCell.swift
//  TechnicalWorld
//
//  Created by Rohit Dhakad on 23/12/21.
//

import UIKit

class SubmittedTableViewCell: UITableViewCell {

    @IBOutlet var vwContainer: UIView!
    @IBOutlet var vwImgContainer: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var btnWhatsapp: UIButton!
    @IBOutlet var btnCall: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
