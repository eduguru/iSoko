//
//  ImageTitleDescriptionBottomCell.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

public final class ImageTitleDescriptionBottomCell: UITableViewCell {

    // MARK: - Views
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    
    // New bottom stack for optional label/button
    private let bottomStack = UIStackView()
    private var bottomLabel: UILabel?
    private var bottomButton: UIButton?

    private var accessory: UIView?
    private var onTap: (() -> Void)?

    private var internalPadding: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    private var spacing: CGFloat = 12

    // MARK: - Init
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

    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Icon
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)

        // Text stack
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

        // Bottom stack
        bottomStack.axis = .vertical
        bottomStack.spacing = 4
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    private func setupOuterConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Icon
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
            iconContainerView.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),

            iconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor, constant: 1),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: -1),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: 1),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -1),

            // Text stack
            textStack.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: spacing),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: internalPadding.top),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),

            // Bottom stack
            bottomStack.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: textStack.trailingAnchor),
            bottomStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 8),
            bottomStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -internalPadding.bottom)
        ])
    }

    // MARK: - Configure
    public func configure(with config: ImageTitleDescriptionBottomConfig) {
        onTap = config.onTap
        internalPadding = config.contentInsets
        spacing = config.spacing

        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        // Clear bottom stack
        bottomStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        bottomLabel = nil
        bottomButton = nil

        // Configure bottom content
        if let bottomText = config.bottomLabelText {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .footnote)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.text = bottomText
            bottomStack.addArrangedSubview(label)
            bottomLabel = label
        } else if let buttonTitle = config.bottomButtonTitle {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
            bottomStack.addArrangedSubview(button)
            bottomButton = button
        }

        // Icon image
        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? 20 : 0
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit

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

    // MARK: - Actions
    @objc private func handleTap() {
        onTap?()
    }

    @objc private func bottomButtonTapped() {
        onTap?()
    }
}
