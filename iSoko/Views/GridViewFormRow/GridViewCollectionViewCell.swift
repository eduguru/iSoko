//
//  GridViewCollectionViewCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

class GridViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var container: UIView!
    @IBOutlet var stackView: UIStackView!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func handleFavTap(_ sender: UIButton) {
        
    }
}
