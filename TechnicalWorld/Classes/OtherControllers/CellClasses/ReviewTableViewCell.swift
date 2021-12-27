//
//  ReviewTableViewCell.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 26/12/21.
//

import UIKit

class ReviewTableViewCell: UITableViewCell,FloatRatingViewDelegate {

    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var ratingVw: FloatRatingView!
    @IBOutlet var lblReviewText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ratingVw.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
