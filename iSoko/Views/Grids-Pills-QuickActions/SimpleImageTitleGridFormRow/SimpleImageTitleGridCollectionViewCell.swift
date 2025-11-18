//
//  SimpleImageTitleGridCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import UIKit

class SimpleImageTitleGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    private var item: SimpleImageTitleGridModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.secondarySystemBackground

        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        containerView.addGestureRecognizer(tapGesture)
    }

    func configure(with item: SimpleImageTitleGridModel) {
        self.item = item
        
        // Use Kingfisher if imageUrl exists, otherwise fallback to image
        if let urlString = item.imageUrl, let url = URL(string: urlString) {
            icon.kf.setImage(with: url, placeholder: item.image)
        } else {
            icon.image = item.image
            icon.tintColor = .app(.primary)
        }
        
        title.text = item.title
        title.font = UIFont.preferredFont(forTextStyle: .body)
        
        title.numberOfLines = 0
        title.lineBreakMode = EllipsisType.none.lineBreakMode
    }
    
    @objc private func handleCellTap() {
        item?.onTap?()
    }
}

