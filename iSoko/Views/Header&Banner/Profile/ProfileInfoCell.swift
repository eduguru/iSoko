//
//  ProfileInfoCell.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//


import UIKit

public final class ProfileInfoCell: UITableViewCell {

    private let containerView = UIView()

    private let nameIconView = UIImageView()
    private let nameLabel = UILabel()
    private let editButton = InlineActionButton()

    private let topRow = UIStackView()
    private let contentStack = UIStackView()

    private var infoRowViews: [IconTextRowView] = []

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        nameIconView.image = UIImage(systemName: "person.fill")
        nameIconView.tintColor = .label
        nameIconView.setContentHuggingPriority(.required, for: .horizontal)

        nameLabel.font = .preferredFont(forTextStyle: .headline)

        // Top row
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.alignment = .center
        topRow.addArrangedSubview(nameIconView)
        topRow.addArrangedSubview(nameLabel)
        topRow.addArrangedSubview(UIView())
        topRow.addArrangedSubview(editButton)

        // Content stack
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(topRow)

        containerView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configure

    public func configure(with config: ProfileInfoCellConfig) {

        nameIconView.image = config.nameIcon
        nameLabel.text = config.name

        // 1. Clear previous dynamic rows
        infoRowViews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        infoRowViews.removeAll()

        // 2. Add dynamic rows
        for item in config.infoItems {

            let row = IconTextRowView()
            row.configure(
                text: item.text,
                icon: item.icon
            )

            contentStack.addArrangedSubview(row)
            infoRowViews.append(row)
        }

        // 3. Edit button
        if let onEdit = config.onEditTap {
            editButton.configure(
                with: InlineActionConfig(
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: onEdit
                )
            )
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }

        // 4. Styling
        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderWidth = config.cardBorderWidth
        containerView.layer.borderColor = config.cardBorderColor.cgColor
    }
}
