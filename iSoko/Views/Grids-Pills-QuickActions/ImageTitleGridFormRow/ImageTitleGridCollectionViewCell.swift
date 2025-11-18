//
//  ImageTitleGridCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit
import Kingfisher

class ImageTitleGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var item: ImageTitleGridItemModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.secondarySystemBackground

        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        containerView.addGestureRecognizer(tapGesture)
    }

    func configure(with item: ImageTitleGridItemModel) {
        self.item = item
        
        // Use Kingfisher if imageUrl exists, otherwise fallback to image
        if let urlString = item.imageUrl, let url = URL(string: urlString) {
            itemImageView.kf.setImage(with: url, placeholder: item.image)
        } else {
            itemImageView.image = item.image
        }
        
        titleLabel.text = item.title
        descLabel.text = item.subtitle

        descLabel.isHidden = item.subtitle == nil
    }

    @objc private func handleCellTap() {
        item?.onTap?()
    }
}
