//
//  ArticleItemViewCell.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import UIKit

class ArticleItemViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgThumb: UIImageView!
    
    @IBOutlet weak var stackSecondary: UIStackView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var labelSecondary: UILabel!
    @IBOutlet weak var labelCallout: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
