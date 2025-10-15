//
//  QuickActionItemCell.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import UIKit
import Kingfisher

final class QuickActionItemCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: QuickActionItem) {
        // Use Kingfisher if imageUrl exists, otherwise fallback to image
        if let urlString = item.imageUrl, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: item.image)
        } else {
            imageView.image = item.image
        }
        
        titleLabel.text = item.title
        titleLabel.font = item.titleFont
        titleLabel.textColor = item.titleColor

        imageView.layer.cornerRadius = {
            switch item.imageShape {
            case .circle: return item.imageSize.width / 2
            case .rounded(let radius): return radius
            case .square: return 0
            }
        }()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: item.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: item.imageSize.height)
        ])
    }
}
