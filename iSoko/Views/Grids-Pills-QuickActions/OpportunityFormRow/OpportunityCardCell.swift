//
//  OpportunityCardCell.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

final class OpportunityCardCell: UICollectionViewCell {

    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let locationLabel = UILabel()
    private let locationIcon = UIImageView()
    private let categoryBadge = UILabel()

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

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // IMAGE
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 16
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // TEXT
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        locationIcon.tintColor = .secondaryLabel
        locationIcon.contentMode = .scaleAspectFit

        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel

        categoryBadge.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryBadge.textColor = .black
        categoryBadge.textAlignment = .center
        categoryBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.18)
        categoryBadge.layer.cornerRadius = 10
        categoryBadge.clipsToBounds = true

        // STACKS
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        locationStack.axis = .horizontal
        locationStack.spacing = 6
        locationStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [subtitleLabel, categoryBadge])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 8
        bottomStack.alignment = .center
        bottomStack.distribution = .fillProportionally

        let textStack = UIStackView(arrangedSubviews: [titleLabel, bottomStack, locationStack])
        textStack.axis = .vertical
        textStack.spacing = 10

        // ADD TO HIERARCHY
        contentView.addSubview(mainImageView)
        contentView.addSubview(textStack)

        // IMPORTANT: constraints after addSubview
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Image constraints
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.65),

            // Text constraints
            textStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            // Icon fixed size
            locationIcon.widthAnchor.constraint(equalToConstant: 16),
            locationIcon.heightAnchor.constraint(equalToConstant: 16),

            // Badge size
            categoryBadge.heightAnchor.constraint(equalToConstant: 28),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }


    func configure(with item: OpportunityItem) {
        mainImageView.image = item.image ?? UIImage(systemName: "photo")

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle ?? ""

        locationLabel.text = item.location ?? "Unknown"

        if let category = item.category {
            categoryBadge.text = "  \(category)  "
            categoryBadge.isHidden = false
        } else {
            categoryBadge.isHidden = true
        }
    }
}
