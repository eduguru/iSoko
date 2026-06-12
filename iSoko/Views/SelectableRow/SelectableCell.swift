//
//  SelectableCell.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit

// MARK: - 1. Selectable Card Cell
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

        // Key outer constraints to space cards away from each other gracefully
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Flexible Title layout logic
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.lineBreakMode = .byTruncatingTail

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

        // INCREASED PADDING: Raised inner padding constants from 12 to 16 for cleaner breathing room
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            selectionIcon.widthAnchor.constraint(equalToConstant: 24),
            selectionIcon.heightAnchor.constraint(equalToConstant: 24),

            accessoryIcon.widthAnchor.constraint(equalToConstant: 24),
            accessoryIcon.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSelection))
        containerView.addGestureRecognizer(tap)
    }

    public func configure(with config: SelectableRowConfig) {
        // Sanitize incoming raw string patterns to capitalized case formats gracefully
        titleLabel.text = config.title.lowercased().capitalized
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
        selectionIcon.tintColor = .app(.primary)
    }

    @objc private func toggleSelection() {
        isSelectedState.toggle()
        updateSelectionIcon()
        onToggle?(isSelectedState)
    }
}
