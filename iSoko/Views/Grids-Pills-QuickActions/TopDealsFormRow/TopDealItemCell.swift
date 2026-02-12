//
//  TopDealItemCell.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

final class TopDealItemCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let badgeLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()

    private var currentItem: TopDealItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        // Optional soft shadow (natural UI feel)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        badgeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        badgeLabel.textColor = .label
        badgeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.layer.masksToBounds = true
        badgeLabel.textAlignment = .center

        favoriteButton.tintColor = .white
        favoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        favoriteButton.layer.cornerRadius = 18
        favoriteButton.clipsToBounds = true
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        priceLabel.font = .systemFont(ofSize: 16, weight: .medium)

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            priceLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4

        contentView.addSubview(imageView)
        contentView.addSubview(badgeLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(textStack)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            badgeLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            badgeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),

            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36),

            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with item: TopDealItem) {

        currentItem = item

        if let urlString = item.imageUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: item.image)
        } else {
            imageView.image = item.image
        }

        badgeLabel.text = item.badgeText
        badgeLabel.isHidden = item.badgeText == nil

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        subtitleLabel.isHidden = item.subtitle == nil
        priceLabel.text = item.priceText

        updateFavoriteUI(isFavorite: item.isFavorite)
    }

    private func updateFavoriteUI(isFavorite: Bool) {

        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .white
    }

    @objc private func favoriteTapped() {

        guard var item = currentItem else { return }

        item.isFavorite.toggle()
        currentItem = item

        updateFavoriteUI(isFavorite: item.isFavorite)

        item.onFavoriteToggle?(item.isFavorite)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        currentItem = nil
    }
}
