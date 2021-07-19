//
//  BidsTableViewCell.swift
//  TechnicalWorld
//
//  Created by Paras on 16/04/21.
//

import UIKit

class BidsTableViewCell: UITableViewCell {

    @IBOutlet var imgVwBid: UIImageView!
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblBidCount: UILabel!
    @IBOutlet var lblBidBy: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
