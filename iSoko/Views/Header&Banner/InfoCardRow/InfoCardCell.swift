//
//  InfoCardCell.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public final class InfoCardCell: UITableViewCell {

    private let containerView = UIView()

    private let titleIconView = UIImageView()
    private let titleLabel = UILabel()
    private let editButton = InlineActionButton()

    private let titleRow = UIStackView()
    private let rowsStack = UIStackView()
    private let statusPill = StatusPillView()
    private let contentStack = UIStackView()

    private var rowViews: [IconValueRowView] = []

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

        titleLabel.font = .preferredFont(forTextStyle: .title3)

        titleIconView.contentMode = .scaleAspectFit
        titleIconView.setContentHuggingPriority(.required, for: .horizontal)

        editButton.configure(
            with: InlineActionConfig(
                title: "Edit",
                icon: UIImage(systemName: "pencil")
            )
        )

        titleRow.axis = .horizontal
        titleRow.spacing = 8
        titleRow.addArrangedSubview(titleIconView)
        titleRow.addArrangedSubview(titleLabel)
        titleRow.addArrangedSubview(UIView())
        titleRow.addArrangedSubview(editButton)

        rowsStack.axis = .vertical
        rowsStack.spacing = 12

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(titleRow)
        contentStack.addArrangedSubview(rowsStack)
        contentStack.addArrangedSubview(statusPill)

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

    public func configure(with config: InfoCardCellConfig) {
        titleLabel.text = config.title
        titleIconView.image = config.titleIcon
        titleIconView.isHidden = config.titleIcon == nil

        editButton.isHidden = config.onEditTap == nil
        editButton.configure(
            with: InlineActionConfig(
                title: "Edit",
                icon: UIImage(systemName: "pencil"),
                onTap: config.onEditTap
            )
        )

        rowsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        config.rows.forEach { row in
            let view = IconValueRowView()
            view.configure(icon: row.icon, text: row.text)
            rowsStack.addArrangedSubview(view)
        }

        statusPill.configure(
            text: config.statusText,
            textColor: config.statusTextColor,
            backgroundColor: config.statusBackgroundColor
        )

        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderColor = config.cardBorderColor.cgColor
        containerView.layer.borderWidth = config.cardBorderWidth
    }
}
