//
//  ImageTitleDescriptionCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public final class ImageTitleDescriptionCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    private var accessory: UIView?

    private var onTap: (() -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill

        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        contentView.addSubview(textStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
    }

    public func configure(with config: ImageTitleDescriptionConfig) {
        onTap = config.onTap
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        // Image
        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? config.imageSize.height / 2 : 0

        // Remove old accessory
        accessory?.removeFromSuperview()
        accessory = nil

        // Add accessory
        applyAccessory(config.accessoryType)

        if let accessory = accessory {
            accessory.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(accessory)
        }

        // Constraints
        NSLayoutConstraint.deactivate(contentView.constraints)

        let padding = config.contentInsets

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.left),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: config.imageSize.height),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: config.spacing),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: padding.top),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding.bottom)
        ])

        if let accessory = accessory {
            NSLayoutConstraint.activate([
                accessory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding.right),
                accessory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                textStack.trailingAnchor.constraint(lessThanOrEqualTo: accessory.leadingAnchor, constant: -config.spacing)
            ])
        } else {
            NSLayoutConstraint.activate([
                textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding.right)
            ])
        }

        // Enable/disable
        contentView.alpha = config.isEnabled ? 1.0 : 0.5
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

        case .image(let image):
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = UIColor.app(.primary) // or any other themed color
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // adjust as needed

            accessoryType = .none
            accessoryView = imageView
        }
    }

    @objc private func handleTap() {
        onTap?()
    }
}
