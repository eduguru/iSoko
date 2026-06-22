//
//  ImageTitleGridCardCell.swift
//  
//
//  Created by Edwin Weru on 22/06/2026.
//

import UIKit
import DesignSystemKit

final class ImageTitleGridCardCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageTitleGridCardCell"

    private let cardView = UIView()
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    private var item: ImageTitleGridItemModel?
    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

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

        itemImageView.kf.cancelDownloadTask()
        itemImageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        descLabel.isHidden = false
        item = nil
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.masksToBounds = false

        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 14
        itemImageView.layer.cornerCurve = .continuous
        itemImageView.backgroundColor = .systemGray5

        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.lineBreakMode = .byTruncatingTail

        descLabel.font = .systemFont(ofSize: 11, weight: .regular)
        descLabel.textColor = .tertiaryLabel
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 2
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.minimumScaleFactor = 0.75
        descLabel.lineBreakMode = .byTruncatingTail

        let stack = UIStackView(arrangedSubviews: [
            itemImageView,
            titleLabel,
            descLabel
        ])

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 6

        contentView.addSubview(cardView)
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -8),

            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 0.78)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
    }

    func configure(with item: ImageTitleGridItemModel) {
        self.item = item

        let presentableTitle = item.title.lowercased().capitalized
        titleLabel.text = presentableTitle
        descLabel.text = item.subtitle
        descLabel.isHidden = item.subtitle?.isEmpty ?? true

        if let urlString = item.imageUrl,
           let url = URL(string: urlString) {
            itemImageView.kf.setImage(
                with: url,
                placeholder: item.image,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            itemImageView.image = item.image
        }
    }

    @objc private func handleCellTap() {
        item?.onTap?()
    }
}
