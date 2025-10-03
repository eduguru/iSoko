//
//  ImageTitleDescriptionCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public final class ImageTitleDescriptionCell: UITableViewCell {

    private let containerView = UIView()
    private let iconContainerView = UIView()  // New container for icon with padding
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    private var accessory: UIView?

    private var onTap: (() -> Void)?

    // Padding inside the card
    private var internalPadding: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    private var spacing: CGFloat = 12

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupOuterConstraints()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupOuterConstraints()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Setup icon container view
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)

        // Setup icon image view
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)

        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)

        containerView.addSubview(textStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    private func setupOuterConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    public func configure(with config: ImageTitleDescriptionConfig) {
        onTap = config.onTap

        // Padding setup
        internalPadding = config.isCardStyleEnabled ? config.contentInsets : UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        spacing = config.spacing

        // Text setup
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        // Clear old accessory
        accessory?.removeFromSuperview()
        accessory = nil

        // Apply new accessory
        applyAccessory(config.accessoryType)

        // Clear subviews before adding
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(iconContainerView)
        containerView.addSubview(textStack)
        if let accessory = accessory {
            containerView.addSubview(accessory)
        }

        // Setup iconContainerView size (fixed size with padding inside)
        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            iconContainerView.heightAnchor.constraint(equalToConstant: config.imageSize.height)
        ])

        // iconImageView with inset inside container (1 or 2 px padding)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor, constant: 1),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: -1),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: 1),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -1)
        ])

        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? (config.imageSize.height / 2) - 1 : 0
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit

        // Setup textStack constraints
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: spacing),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: internalPadding.top),
            textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -internalPadding.bottom),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        if let accessory = accessory {
            NSLayoutConstraint.activate([
                accessory.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),
                accessory.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                textStack.trailingAnchor.constraint(lessThanOrEqualTo: accessory.leadingAnchor, constant: -spacing)
            ])
        } else {
            NSLayoutConstraint.activate([
                textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right)
            ])
        }

        // Card style
        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor.cgColor
            containerView.backgroundColor = config.cardBackgroundColor
        } else {
            containerView.layer.cornerRadius = 0
            containerView.layer.borderWidth = 0
            containerView.backgroundColor = .clear
        }

        containerView.alpha = config.isEnabled ? 1.0 : 0.5
        isUserInteractionEnabled = config.isEnabled
    }

    private func applyAccessory(_ type: ImageTitleDescriptionConfig.AccessoryType) {
        switch type {
        case .none:
            accessoryType = .none
            accessoryView = nil

        case .chevron:
            accessoryType = .disclosureIndicator
            accessoryView = nil

        case .custom(let view):
            accessoryType = .none
            accessoryView = view
            accessory = view

        case .image(let image):
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = UIColor.app(.primary)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            accessory = imageView
        }
    }

    @objc private func handleTap() {
        onTap?()
    }
}
