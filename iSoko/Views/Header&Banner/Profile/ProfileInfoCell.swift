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

    private let phoneRow = IconTextRowView()
    private let emailRow = IconTextRowView()
    private let locationRow = IconTextRowView()

    private let topRow = UIStackView()
    private let contentStack = UIStackView()

    private var onEditTap: (() -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        nameIconView.image = UIImage(systemName: "person.fill")
        nameIconView.tintColor = .label
        nameIconView.setContentHuggingPriority(.required, for: .horizontal)

        nameLabel.font = .preferredFont(forTextStyle: .headline)

        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.alignment = .center
        topRow.addArrangedSubview(nameIconView)
        topRow.addArrangedSubview(nameLabel)
        topRow.addArrangedSubview(UIView())
        topRow.addArrangedSubview(editButton)

        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(topRow)
        contentStack.addArrangedSubview(phoneRow)
        contentStack.addArrangedSubview(emailRow)
        contentStack.addArrangedSubview(locationRow)

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

    public func configure(with config: ProfileInfoCellConfig) {
        nameLabel.text = config.name

        phoneRow.configure(
            text: config.phone,
            icon: UIImage(systemName: "phone.fill")
        )

        emailRow.configure(
            text: config.email,
            icon: UIImage(systemName: "envelope.fill")
        )

        locationRow.configure(
            text: config.location,
            icon: UIImage(systemName: "mappin.and.ellipse")
        )

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

        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderWidth = config.cardBorderWidth
        containerView.layer.borderColor = config.cardBorderColor.cgColor
    }
}
