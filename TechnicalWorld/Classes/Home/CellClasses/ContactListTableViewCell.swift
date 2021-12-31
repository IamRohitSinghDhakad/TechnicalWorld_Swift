//
//  ContactListTableViewCell.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var vwBoxShadow: UIView!
    @IBOutlet var ratingVwCompany: FloatRatingView!
    @IBOutlet var ratingVwindividual: FloatRatingView!
    @IBOutlet var lblCountRatingCompany: UILabel!
    @IBOutlet var lblCountRatingIndividual: UILabel!
    @IBOutlet var btnWhatsApp: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var lblCompanies: UILabel!
    @IBOutlet var lblIndividuals: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBoxShadow.viewShadowHeaderWithCorner(corner: 8)
        self.imgVwUser.clipsToBounds = false
        self.imgVwUser.viewShadowHeaderWithCorner(corner: 8)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
