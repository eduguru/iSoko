//
//  GridViewCollectionViewCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit
import DesignSystemKit
import Kingfisher

final class GridViewCollectionViewCell: UICollectionViewCell {

    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

    private let container = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let favButton = UIButton(type: .system)

    private var item: GridItemModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil

        titleLabel.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil

        subtitleLabel.isHidden = false
        priceLabel.isHidden = false

        item = nil
        updateFavoriteIcon(isFavorite: false)
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        container.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false

        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5

        favButton.tintColor = .white
        favButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        favButton.layer.cornerRadius = 18
        favButton.clipsToBounds = true
        favButton.addTarget(self, action: #selector(handleFavTap(_:)), for: .touchUpInside)
        favButton.isHidden = true

        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byTruncatingTail

        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.numberOfLines = 1
        priceLabel.lineBreakMode = .byTruncatingTail

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            priceLabel
        ])

        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 4

        contentView.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(favButton)
        container.addSubview(textStack)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.95),

            favButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            favButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            favButton.widthAnchor.constraint(equalToConstant: 36),
            favButton.heightAnchor.constraint(equalToConstant: 36),

            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            textStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -12)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
    }

    func configure(with item: GridItemModel) {
        self.item = item

        if let urlString = item.imageUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(
                with: url,
                placeholder: item.image,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            imageView.image = item.image
        }

        titleLabel.text = item.title.lowercased().capitalized
        subtitleLabel.text = item.subtitle?.lowercased().capitalized
        priceLabel.text = item.price

        subtitleLabel.isHidden = item.subtitle?.isEmpty ?? true
        priceLabel.isHidden = item.price?.isEmpty ?? true

        titleLabel.lineBreakMode = AppEllipsisType.none.lineBreakMode
        subtitleLabel.lineBreakMode = AppEllipsisType.none.lineBreakMode
        priceLabel.lineBreakMode = AppEllipsisType.none.lineBreakMode

        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        updateFavoriteIcon(isFavorite: item.isFavorite)
    }

    @objc func handleFavTap(_ sender: UIButton) {
        guard var model = item else { return }

        model.isFavorite.toggle()
        updateFavoriteIcon(isFavorite: model.isFavorite)
        model.onToggleFavorite?(model.isFavorite)

        self.item = model
    }

    private func updateFavoriteIcon(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)

        favButton.setImage(image, for: .normal)
        favButton.setTitle("", for: .normal)
        favButton.tintColor = isFavorite ? .systemRed : .white
    }

    @objc private func handleCellTap() {
        item?.onTap?()
    }
}
