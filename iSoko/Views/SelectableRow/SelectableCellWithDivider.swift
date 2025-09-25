//
//  SelectableCellWithDivider.swift
//
//
//  Created by Edwin Weru on 25/09/2025.
//

import UIKit

public final class SelectableCellWithDivider: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textStack = UIStackView()
    private let selectionIcon = UIImageView()
    private let accessoryIcon = UIImageView()
    private let divider = UIView()

    private var onToggle: ((Bool) -> Void)?
    private var isSelectedState: Bool = false
    private var selectionType: SelectableRowConfig.SelectionStyle = .checkbox

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
        selectionIcon.setContentHuggingPriority(.required, for: .horizontal)
        selectionIcon.translatesAutoresizingMaskIntoConstraints = false

        accessoryIcon.contentMode = .scaleAspectFit
        accessoryIcon.setContentHuggingPriority(.required, for: .horizontal)
        accessoryIcon.translatesAutoresizingMaskIntoConstraints = false

        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .separator

        let mainStack = UIStackView(arrangedSubviews: [selectionIcon, textStack, accessoryIcon])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)
        contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -12),

            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            selectionIcon.widthAnchor.constraint(equalToConstant: 24),
            selectionIcon.heightAnchor.constraint(equalToConstant: 24),

            accessoryIcon.widthAnchor.constraint(equalToConstant: 24),
            accessoryIcon.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSelection))
        contentView.addGestureRecognizer(tap)
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

        contentView.alpha = config.isEnabled ? 1.0 : 0.5
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
