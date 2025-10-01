//
//  ImageTitleDescriptionCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public final class ImageTitleDescriptionCell: UITableViewCell {

    private let containerView = UIView()
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

        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)

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
        
        if config.isCardStyleEnabled { // Adjust padding based on card style
            internalPadding = config.contentInsets
        } else { // Reduce padding when card is disabled
            internalPadding = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }

        
        
        spacing = config.spacing

        // Text
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        // Image
        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? config.imageSize.height / 2 : 0
        iconImageView.layer.masksToBounds = true

        // Size constraints for image
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: config.imageSize.height)
        ])

        // Remove old accessory
        accessory?.removeFromSuperview()
        accessory = nil

        // Add accessory
        applyAccessory(config.accessoryType)

        // Clear old constraints inside container
        NSLayoutConstraint.deactivate(containerView.constraints)

        // Layout all views inside container with internal padding
        iconImageView.removeFromSuperview()
        textStack.removeFromSuperview()
        accessory?.removeFromSuperview()

        containerView.addSubview(iconImageView)
        containerView.addSubview(textStack)
        if let accessory = accessory {
            containerView.addSubview(accessory)
        }

        // Build constraints again
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: spacing),
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
