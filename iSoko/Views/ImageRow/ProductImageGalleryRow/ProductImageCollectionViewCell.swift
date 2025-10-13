//
//  ProductImageCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import UIKit
import Kingfisher

final class ProductImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductImageCollectionViewCell"

    private let imageView = UIImageView()
    private let featuredFlag = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        featuredFlag.text = "FEATURED"
        featuredFlag.textColor = .white
        featuredFlag.font = .boldSystemFont(ofSize: 12)
        featuredFlag.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        featuredFlag.textAlignment = .center
        featuredFlag.layer.cornerRadius = 4
        featuredFlag.clipsToBounds = true
        featuredFlag.isHidden = true
        contentView.addSubview(featuredFlag)
        featuredFlag.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            featuredFlag.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            featuredFlag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            featuredFlag.widthAnchor.constraint(equalToConstant: 80),
            featuredFlag.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with productImage: ProductImage, placeholder: UIImage? = nil) {
        featuredFlag.isHidden = !productImage.isFeatured
        imageView.kf.setImage(with: productImage.url, placeholder: placeholder)
    }
}
