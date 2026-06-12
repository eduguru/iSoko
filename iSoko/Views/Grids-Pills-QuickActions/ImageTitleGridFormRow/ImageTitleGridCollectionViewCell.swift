//
//  ImageTitleGridCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit
import Kingfisher
import DesignSystemKit

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

        // Configure Title Label for wrapping and auto-scaling
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.lineBreakMode = .byTruncatingTail

        // UPDATED: Configure Description Label for 2 lines and auto-scaling
        descLabel.numberOfLines = 2
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.minimumScaleFactor = 0.75
        descLabel.lineBreakMode = .byTruncatingTail

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
        
        // Maps to item.itemTitle and sanitizes harsh uppercase input
        titleLabel.text = item.title.lowercased().capitalized
        descLabel.text = item.subtitle

        descLabel.isHidden = item.subtitle == nil
        
        applyStyling(to: titleLabel, style: .callout)
    }

    @objc private func handleCellTap() {
        item?.onTap?()
    }
    
    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide
    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
