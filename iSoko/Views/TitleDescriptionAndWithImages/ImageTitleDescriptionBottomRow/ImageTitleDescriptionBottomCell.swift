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
    private let bottomStack = UIStackView()

    private var bottomLabel: UILabel?
    private var bottomButton: UIButton?
    private var accessory: UIView?

    // MARK: - Callbacks
    private var onTap: (() -> Void)?
    private var onBottomButtonTap: (() -> Void)?

    // MARK: - Layout constants
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
        bottomStack.spacing = 6
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomStack)

        // Tap gesture
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

            // Bottom stack
            bottomStack.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: textStack.trailingAnchor),
            bottomStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 8),
            bottomStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -internalPadding.bottom)
        ])
    }

    // MARK: - Configure
    public func configure(with config: ImageTitleDescriptionBottomConfig) {
        // Callbacks
        onTap = config.onTap
        onBottomButtonTap = config.onBottomButtonTap

        // Layout
        internalPadding = config.contentInsets
        spacing = config.spacing

        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        // Reset accessory & bottom content
        accessory?.removeFromSuperview()
        accessory = nil
        bottomStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        bottomLabel = nil
        bottomButton = nil

        // MARK: Bottom label
        if let bottomText = config.bottomLabelText {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .footnote)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.text = bottomText
            bottomStack.addArrangedSubview(label)
            bottomLabel = label
        }

        // MARK: Bottom button
        if let buttonTitle = config.bottomButtonTitle {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 0
            button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)

            switch config.bottomButtonStyle {
            case .primary:
                button.backgroundColor = .app(.primary)
                button.setTitleColor(.white, for: .normal)
            case .secondary:
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.app(.primary).cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(.app(.primary), for: .normal)
            case .plain:
                button.backgroundColor = .clear
                button.setTitleColor(.systemBlue, for: .normal)
            case .custom(let bg, let text):
                button.backgroundColor = bg
                button.setTitleColor(text, for: .normal)
            }

            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 34).isActive = true
            bottomStack.addArrangedSubview(button)
            bottomButton = button
        }

        // MARK: Accessory inside the card
        if let accessoryType = config.accessoryType {
            applyAccessory(accessoryType)
        }

        // MARK: Icon
        iconImageView.image = config.image
        iconImageView.layer.cornerRadius = config.imageStyle == .rounded ? 20 : 0
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit

        // Accessory position inside container
        if let accessory = accessory {
            containerView.addSubview(accessory)
            NSLayoutConstraint.activate([
                accessory.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),
                accessory.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
                textStack.trailingAnchor.constraint(lessThanOrEqualTo: accessory.leadingAnchor, constant: -spacing)
            ])
        } else {
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right).isActive = true
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

    // MARK: - Accessory helper
    private func applyAccessory(_ type: ImageTitleDescriptionBottomConfig.AccessoryType) {
        switch type {
        case .none:
            accessory = nil

        case .chevron:
            let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevron.tintColor = .tertiaryLabel
            chevron.contentMode = .scaleAspectFit
            chevron.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevron.widthAnchor.constraint(equalToConstant: 16),
                chevron.heightAnchor.constraint(equalToConstant: 16)
            ])
            accessory = chevron

        case .custom(let view):
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

    // MARK: - Actions
    @objc private func handleTap() {
        onTap?()
    }

    @objc private func bottomButtonTapped() {
        onBottomButtonTap?()
    }
}
