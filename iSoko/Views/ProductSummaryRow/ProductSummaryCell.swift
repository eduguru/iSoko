//
//  ProductSummaryCell.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit

final class ProductSummaryCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let ratingImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let reviewsLabel = UILabel()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    private let priceLabel = UILabel()
    private let oldPriceLabel = UILabel()
    private let discountPill = UILabel()

    private let ratingStack = UIStackView()
    private let locationStack = UIStackView()
    private let infoStack = UIStackView()
    private let priceStack = UIStackView()
    private let mainStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none

        // Title
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 2

        // Rating Image
        ratingImageView.image = UIImage(systemName: "star.fill")
        ratingImageView.tintColor = .systemYellow
        ratingImageView.contentMode = .scaleAspectFit
        ratingImageView.setContentHuggingPriority(.required, for: .horizontal)

        // Rating label
        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.textColor = .label

        // Reviews label
        reviewsLabel.font = .systemFont(ofSize: 14)
        reviewsLabel.textColor = .secondaryLabel

        // Rating stack (star + rating + reviews)
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        ratingStack.alignment = .center
        ratingStack.addArrangedSubview(ratingImageView)
        ratingStack.addArrangedSubview(ratingLabel)
        ratingStack.addArrangedSubview(reviewsLabel)

        // Location image
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationImageView.tintColor = .secondaryLabel
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.setContentHuggingPriority(.required, for: .horizontal)

        // Location label
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel

        // Location stack (pin + location)
        locationStack.axis = .horizontal
        locationStack.spacing = 4
        locationStack.alignment = .center
        locationStack.addArrangedSubview(locationImageView)
        locationStack.addArrangedSubview(locationLabel)

        // Info stack (rating + location)
        infoStack.axis = .horizontal
        infoStack.spacing = 16
        infoStack.alignment = .center
        infoStack.addArrangedSubview(ratingStack)
        infoStack.addArrangedSubview(locationStack)

        // Price label (e.g., KES 1,699)
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textColor = .systemGreen

        // Old price label (strikethrough)
        oldPriceLabel.font = .systemFont(ofSize: 14)
        oldPriceLabel.textColor = .secondaryLabel

        // Discount pill
        discountPill.font = .systemFont(ofSize: 12, weight: .semibold)
        discountPill.textColor = .systemGreen
        discountPill.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        discountPill.layer.cornerRadius = 8
        discountPill.layer.masksToBounds = true
        discountPill.textAlignment = .center
        discountPill.setContentHuggingPriority(.required, for: .horizontal)
        discountPill.setContentCompressionResistancePriority(.required, for: .horizontal)
        discountPill.translatesAutoresizingMaskIntoConstraints = false
        discountPill.heightAnchor.constraint(equalToConstant: 24).isActive = true
        discountPill.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true

        // Price stack (price, old price, discount)
        priceStack.axis = .horizontal
        priceStack.spacing = 8
        priceStack.alignment = .center
        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(oldPriceLabel)
        priceStack.addArrangedSubview(discountPill)

        // Main vertical stack
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(infoStack)
        mainStack.addArrangedSubview(priceStack)

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    func configure(with model: ProductSummaryModel) {
        titleLabel.text = model.title
        ratingLabel.text = String(format: "%.1f", model.rating)
        reviewsLabel.text = "(\(model.reviewCount) reviews)"
        locationLabel.text = model.location

        priceLabel.text = model.priceText

        if let oldPrice = model.oldPriceText, !oldPrice.isEmpty {
            let attributed = NSAttributedString(
                string: oldPrice,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
            oldPriceLabel.attributedText = attributed
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
        }

        if let discount = model.discountText, !discount.isEmpty {
            discountPill.text = discount
            discountPill.isHidden = false
        } else {
            discountPill.isHidden = true
        }
    }
}
