//
//  ProductThumbnailCell.swift
//  
//
//  Created by Edwin Weru on 09/06/2026.
//

import UIKit

final class ProductThumbnailCell: UICollectionViewCell {

    static let reuseIdentifier = "ProductThumbnailCell"

    private let imageView = UIImageView()
    private let featuredBadge = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {

        layer.cornerRadius = 8
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
        contentView.addSubview(featuredBadge)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        featuredBadge.translatesAutoresizingMaskIntoConstraints = false

        featuredBadge.image = UIImage(systemName: "star.fill")
        featuredBadge.tintColor = .systemYellow

        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),

            imageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            imageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            imageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),

            featuredBadge.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),

            featuredBadge.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -4
            ),

            featuredBadge.widthAnchor.constraint(
                equalToConstant: 16
            ),

            featuredBadge.heightAnchor.constraint(
                equalToConstant: 16
            )
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    func configure(
        with image: ProductImage,
        placeholder: UIImage?,
        selected: Bool
    ) {

        imageView.kf.setImage(
            with: image.url,
            placeholder: placeholder
        )

        featuredBadge.isHidden = !image.isFeatured

        layer.borderWidth = selected ? 2 : 0
        layer.borderColor = selected
            ? UIColor.app(.primary).cgColor
            : UIColor.clear.cgColor

        transform = selected
            ? CGAffineTransform(scaleX: 1.05, y: 1.05)
            : .identity
    }
}
