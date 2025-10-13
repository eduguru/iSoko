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
    
    @IBOutlet var favButton: UIButton!
    
    @IBAction func handleFavTap(_ sender: UIButton) {
        guard var model = item else { return }
        model.isFavorite.toggle()
        updateFavoriteIcon(isFavorite: model.isFavorite)
        model.onToggleFavorite?(model.isFavorite)
        self.item = model // update stored reference
    }


    private var item: GridItemModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        container.backgroundColor = UIColor.secondarySystemBackground

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        container.addGestureRecognizer(tapGesture)
    }


    func configure(with item: GridItemModel) {
        self.item = item

        imageView.image = item.image
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        priceLabel.text = item.price

        subtitleLabel.isHidden = item.subtitle == nil
        priceLabel.isHidden = item.price == nil

        updateFavoriteIcon(isFavorite: item.isFavorite)
    }

    private func updateFavoriteIcon(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favButton.setImage(image, for: .normal)
        favButton.setTitle("", for: .normal)
        favButton.tintColor = isFavorite ? .systemRed : .systemGray
    }

    @objc private func handleCellTap() {
        item?.onTap?()
    }
}
