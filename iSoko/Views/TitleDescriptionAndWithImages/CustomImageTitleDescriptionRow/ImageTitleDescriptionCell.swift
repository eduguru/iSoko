//
//  ImageTitleDescriptionCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public final class ImageTitleDescriptionCell: UITableViewCell {

    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    private var accessory: UIView?

    private var onTap: (() -> Void)?

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

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2

        textStack.axis = .vertical
        textStack.spacing = 4
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

        internalPadding = config.isCardStyleEnabled
        ? config.contentInsets
        : UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        spacing = config.spacing

        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        accessory?.removeFromSuperview()
        accessory = nil
        applyAccessory(config.accessoryType)

        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(iconContainerView)
        containerView.addSubview(textStack)
        if let accessory = accessory {
            containerView.addSubview(accessory)
        }

        // Icon container styling (NEW)
        iconContainerView.backgroundColor = config.iconBackgroundColor ?? .clear
        let radius = config.iconCornerRadius ?? (config.imageSize.height / 2)
        iconContainerView.layer.cornerRadius = radius
        iconContainerView.clipsToBounds = true

        // Icon container constraints
        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            iconContainerView.heightAnchor.constraint(equalToConstant: config.imageSize.height)
        ])

        // Icon image inset
        let inset: CGFloat = 8
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor, constant: inset),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: -inset),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: inset),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -inset)
        ])

        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? (config.imageSize.height / 2) - inset : 0
        iconImageView.clipsToBounds = true

        // Text constraints
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

        // Card styling
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
            accessory = nil

        case .chevron:
            let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            imageView.tintColor = .tertiaryLabel
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16)
            ])
            accessory = imageView

        case .custom(let view):
            accessory = view

        case .image(let image):
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .tertiaryLabel
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
