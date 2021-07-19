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
        self.imgvw.layer.cornerRadius = 8
        self.imgvw.clipsToBounds = true
        self.imgvw.layer.masksToBounds = false
        self.imgvw.layer.shadowRadius = 5
        self.imgvw.layer.shadowOpacity = 0.5
        self.imgvw.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.imgvw.layer.shadowColor = UIColor.black.cgColor
        
        //viewShadowHeaderWithCorner(corner: 5)
       // self.imgvw.viewShadowHeader()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class ViewWithRoundedcornersAndShadow: UIView {
    private var theShadowLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.theShadowLayer == nil {
            let rounding = CGFloat.init(22.0)

            let shadowLayer = CAShapeLayer.init()
            self.theShadowLayer = shadowLayer
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor

            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowRadius = CGFloat.init(3.0)
            shadowLayer.shadowOpacity = Float.init(0.2)
            shadowLayer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)

            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
