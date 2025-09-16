//
//  SelectableCell.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit

public final class SelectableCell: UITableViewCell {
    private let containerView = UIView()  // the card view
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    private let selectionIcon = UIImageView()
    private let accessoryIcon = UIImageView()

    private var onToggle: ((Bool) -> Void)?
    private var isSelectedState: Bool = false
    private var selectionType: SelectableRowConfig.SelectionStyle = .checkbox

    // MARK: - Init

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

        // Add container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Here are the key constraints for insets
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Then setup the internal layout in containerView
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.translatesAutoresizingMaskIntoConstraints = false

        selectionIcon.contentMode = .scaleAspectFit
        selectionIcon.translatesAutoresizingMaskIntoConstraints = false
        selectionIcon.setContentHuggingPriority(.required, for: .horizontal)

        accessoryIcon.contentMode = .scaleAspectFit
        accessoryIcon.translatesAutoresizingMaskIntoConstraints = false
        accessoryIcon.setContentHuggingPriority(.required, for: .horizontal)

        let mainStack = UIStackView(arrangedSubviews: [selectionIcon, textStack, accessoryIcon])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            selectionIcon.widthAnchor.constraint(equalToConstant: 24),
            selectionIcon.heightAnchor.constraint(equalToConstant: 24),

            accessoryIcon.widthAnchor.constraint(equalToConstant: 24),
            accessoryIcon.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSelection))
        containerView.addGestureRecognizer(tap)
    }

    public func configure(with config: SelectableRowConfig) {
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        isSelectedState = config.isSelected
        selectionType = config.selectionStyle
        onToggle = config.onToggle

        updateSelectionIcon()

        if config.isAccessoryVisible, let image = config.accessoryImage {
            accessoryIcon.image = image
            accessoryIcon.isHidden = false
        } else {
            accessoryIcon.isHidden = true
        }

        // Card styling
        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.backgroundColor = config.cardBackgroundColor
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor?.cgColor
            containerView.layer.masksToBounds = true
        } else {
            // if card style is off, maybe remove padding or set container invisible or flat
            containerView.layer.cornerRadius = 0
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = nil
        }

        // Disabled state
        containerView.alpha = config.isEnabled ? 1.0 : 0.5
        isUserInteractionEnabled = config.isEnabled
    }

    private func updateSelectionIcon() {
        let imageName: String
        switch selectionType {
        case .checkbox:
            imageName = isSelectedState ? "checkmark.square.fill" : "square"
        case .radio:
            imageName = isSelectedState ? "largecircle.fill.circle" : "circle"
        }
        selectionIcon.image = UIImage(systemName: imageName)
        // Tint or color accordingly
        selectionIcon.tintColor = UIColor.systemBlue  // or your app primary color
    }

    @objc private func toggleSelection() {
        isSelectedState.toggle()
        updateSelectionIcon()
        onToggle?(isSelectedState)
    }
}
