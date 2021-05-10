//
//  RentTableViewCell.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 13/04/21.
//

import UIKit

class RentTableViewCell: UITableViewCell {

    @IBOutlet var imgvw: UIImageView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnWhatsApp: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var lblCompaniesRatingCount: UILabel!
    @IBOutlet var lblIndividualRatingCount: UILabel!
    @IBOutlet var vwContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwContainer.viewShadowHeader()
        self.imgvw.clipsToBounds = false
       // self.imgvw.viewShadowHeader()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
