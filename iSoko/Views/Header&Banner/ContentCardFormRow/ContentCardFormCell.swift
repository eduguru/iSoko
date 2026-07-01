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

    private var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - Constants

    private let maxImageHeight: CGFloat = 180
    private let minImageHeight: CGFloat = 90

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
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)

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
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )

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
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.clipsToBounds = true
        cardImageView.layer.cornerRadius = 12
        cardImageView.backgroundColor = .clear

        imageHeightConstraint = cardImageView.heightAnchor.constraint(equalToConstant: maxImageHeight)
        imageHeightConstraint.isActive = true

        stackView.addArrangedSubview(cardImageView)
    }

    private func setupLabels() {

        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 16)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
    }

    // MARK: - Reuse

    public override func prepareForReuse() {
        super.prepareForReuse()

        cardImageView.kf.cancelDownloadTask()
        cardImageView.image = nil

        titleLabel.text = nil
        bodyLabel.text = nil

        imageHeightConstraint.constant = maxImageHeight
    }

    // MARK: - Configure

    public func configure(with model: ContentCardModel) {

        cardView.backgroundColor = model.cardSettings.backgroundColor
        cardView.layer.cornerRadius = model.cardSettings.cornerRadius

        if let borderColor = model.cardSettings.borderColor {
            cardView.layer.borderColor = borderColor.cgColor
            cardView.layer.borderWidth = model.cardSettings.borderWidth
        } else {
            cardView.layer.borderWidth = 0
        }

        stackView.layoutMargins = model.cardSettings.contentInsets

        titleLabel.text = model.title
        bodyLabel.text = model.text
        bodyLabel.isHidden = model.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        if let url = model.imageURL {

            cardImageView.isHidden = false
            cardImageView.kf.indicatorType = .activity

            cardImageView.kf.setImage(
                with: url,
                placeholder: model.fallbackImage,
                options: [
                    .transition(.fade(0.25)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in

                guard
                    let self,
                    case .success(let value) = result
                else { return }

                self.updateImageHeight(for: value.image)
            }

        } else if let image = model.image {

            cardImageView.isHidden = false
            cardImageView.kf.cancelDownloadTask()
            cardImageView.image = image
            updateImageHeight(for: image)

        } else {

            cardImageView.kf.cancelDownloadTask()
            cardImageView.isHidden = true
        }
    }

    // MARK: - Image Sizing

    private func updateImageHeight(for image: UIImage) {

        let availableWidth = UIScreen.main.bounds.width - 72

        let ratio = image.size.height / image.size.width
        let calculatedHeight = availableWidth * ratio

        imageHeightConstraint.constant = min(
            max(calculatedHeight, minImageHeight),
            maxImageHeight
        )

        setNeedsLayout()
        layoutIfNeeded()
    }
}
