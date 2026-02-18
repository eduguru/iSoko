//
//  FiltersCell.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

public final class FiltersCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    private let containerView = UIView()
    private let contentStack = UIStackView()
    private let filtersContainerStack = UIStackView()

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

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        messageLabel.font = .preferredFont(forTextStyle: .footnote)
        messageLabel.numberOfLines = 0

        filtersContainerStack.axis = .vertical
        filtersContainerStack.spacing = 12

        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(filtersContainerStack)
        contentStack.addArrangedSubview(messageLabel)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentStack)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // ✅ Proper internal card padding
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    public func configure(with config: FiltersCellConfig) {

        titleLabel.text = config.title
        titleLabel.isHidden = config.title == nil

        messageLabel.text = config.message
        messageLabel.textColor = config.messageColor
        messageLabel.isHidden = config.message == nil

        // Remove old rows (important for reuse)
        filtersContainerStack.arrangedSubviews.forEach {
            filtersContainerStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Build rows dynamically
        for row in config.rows {

            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.alignment = .fill
            rowStack.distribution = row.count > 1 ? .fillEqually : .fill

            for fieldConfig in row {
                let fieldView = FilterFieldView()
                fieldView.configure(with: fieldConfig)
                rowStack.addArrangedSubview(fieldView)
            }

            filtersContainerStack.addArrangedSubview(rowStack)
        }

        // Card styling
        if config.showsCard {
            containerView.backgroundColor = config.cardBackgroundColor
            containerView.layer.cornerRadius = config.cardCornerRadius
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = 0
        }
    }
}
