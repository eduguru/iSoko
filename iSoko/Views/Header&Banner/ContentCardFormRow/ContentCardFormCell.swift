//
//  ContentCardFormCell.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import Kingfisher
import UIKit

public final class ContentCardFormCell: UITableViewCell {

    // MARK: - Views
    private let cardView = UIView()
    private let stackView = UIStackView()
    private let cardImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

    // MARK: - Constraints
    private var imageHeightConstraint: NSLayoutConstraint?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupCardView()
        setupStackView()
        setupImageView()
        setupLabels()
    }

    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        cardView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }

    private func setupImageView() {
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.contentMode = .scaleAspectFill // show central part of image
        cardImageView.clipsToBounds = true

        imageHeightConstraint = cardImageView.heightAnchor.constraint(equalToConstant: 180)
        imageHeightConstraint?.isActive = true

        stackView.addArrangedSubview(cardImageView)
    }

    private func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 28)

        bodyLabel.numberOfLines = 0
        bodyLabel.font = .systemFont(ofSize: 18)
        bodyLabel.textColor = .secondaryLabel

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
    }

    // MARK: - Reuse
    public override func prepareForReuse() {
        super.prepareForReuse()
        cardImageView.kf.cancelDownloadTask()
        cardImageView.image = nil
    }

    // MARK: - Configure
    public func configure(with model: ContentCardModel) {
        // Card Style
        cardView.backgroundColor = model.cardSettings.backgroundColor
        cardView.layer.cornerRadius = model.cardSettings.cornerRadius
        if let borderColor = model.cardSettings.borderColor {
            cardView.layer.borderColor = borderColor.cgColor
            cardView.layer.borderWidth = model.cardSettings.borderWidth
        } else {
            cardView.layer.borderWidth = 0
        }
        stackView.layoutMargins = model.cardSettings.contentInsets

        // Text
        titleLabel.text = model.title
        bodyLabel.text = model.text
        bodyLabel.isHidden = model.text?.isEmpty ?? true

        // Image Height
        let maxHeight = model.maxImageHeight ?? 180
        let height = model.imageHeight ?? maxHeight
        imageHeightConstraint?.constant = min(height, maxHeight)

        // Image Alignment (optional: you can still support .left/.center/.right)
        cardImageView.layer.contentsGravity = {
            switch model.imagePosition {
            case .left: return .left
            case .center: return .center
            case .right: return .right
            }
        }()

        // Image Loading
        if let url = model.imageURL {
            cardImageView.kf.indicatorType = .activity
            cardImageView.kf.setImage(
                with: url,
                placeholder: model.fallbackImage,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else if let image = model.image {
            cardImageView.kf.cancelDownloadTask()
            cardImageView.image = image
        } else {
            cardImageView.kf.cancelDownloadTask()
            cardImageView.image = model.fallbackImage
        }

        // Hide image if absent
        cardImageView.isHidden = model.imageURL == nil && model.image == nil
    }
}
