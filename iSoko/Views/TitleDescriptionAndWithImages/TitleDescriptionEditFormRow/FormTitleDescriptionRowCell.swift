//
//  FormTitleDescriptionRowCell.swift
//  
//
//  Created by Edwin Weru on 02/10/2025.
//

import UIKit

public final class FormTitleDescriptionRowCell: UITableViewCell {

    private let containerView = UIView()
    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let trailingImageView = UIImageView()
    private let editButton = UIButton(type: .system)

    private var onTap: (() -> Void)?

    // Layout config
    private var internalPadding: UIEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
    private var spacing: CGFloat = 12

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Title
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        // Description
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        // Stack
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)

        containerView.addSubview(textStack)

        // Trailing image
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        trailingImageView.isHidden = true
        containerView.addSubview(trailingImageView)

        // Edit button
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        editButton.isHidden = true
        editButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(editButton)

        // Tap gesture for whole row
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: internalPadding.top),
            textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -internalPadding.bottom),
            textStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
        ])

        NSLayoutConstraint.activate([
            trailingImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),
            trailingImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            trailingImageView.widthAnchor.constraint(equalToConstant: 24),
            trailingImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),
            editButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Space between text and trailing items
        textStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingImageView.leadingAnchor, constant: -spacing).isActive = true
        textStack.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -spacing).isActive = true
    }

    public func configure(with config: FormTitleDescriptionRowConfig) {
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        onTap = config.onTap

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

        // Edit button
        if config.showEditButton {
            editButton.setTitle(config.editButtonTitle ?? "Edit", for: .normal)
            editButton.isHidden = false
            trailingImageView.isHidden = true
            editButton.addAction(UIAction(handler: { _ in config.onEditTap?() }), for: .touchUpInside)
        } else {
            editButton.isHidden = true
        }

        // Trailing image
        if let image = config.trailingImage {
            trailingImageView.image = image
            trailingImageView.isHidden = false
        } else {
            trailingImageView.isHidden = true
        }

        containerView.alpha = config.isEnabled ? 1.0 : 0.5
        isUserInteractionEnabled = config.isEnabled
    }

    @objc private func handleTap() {
        onTap?()
    }
}
