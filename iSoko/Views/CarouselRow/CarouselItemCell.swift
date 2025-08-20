//
//  CarouselItemCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

final class CarouselItemCell: UICollectionViewCell {
    static let reuseIdentifier = "CarouselItemCell"

    private let imageView = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with item: CarouselItem, contentMode: UIView.ContentMode, hideText: Bool = false) {
        imageView.contentMode = contentMode
        imageView.image = item.image
        label.text = item.text
        label.textColor = item.textColor
        label.isHidden = hideText || (item.text == nil)
    }
}
