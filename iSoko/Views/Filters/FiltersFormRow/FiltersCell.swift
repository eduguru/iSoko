//
//  FiltersCell.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

// MARK: - Filters Cell
public final class FiltersCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    private let containerView = UIView()
    private let contentStack = UIStackView()
    private let filtersContainerStack = UIStackView()

    private var topC: NSLayoutConstraint!
    private var bottomC: NSLayoutConstraint!
    private var leadingC: NSLayoutConstraint!
    private var trailingC: NSLayoutConstraint!

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

        topC = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        bottomC = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        leadingC = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        trailingC = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        NSLayoutConstraint.activate([
            topC, bottomC, leadingC, trailingC,

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

        // Clear reuse
        filtersContainerStack.arrangedSubviews.forEach {
            filtersContainerStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Build rows
        for row in config.rows {

            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.alignment = .fill
            rowStack.distribution = row.count > 1 ? .fillEqually : .fill

            for fieldConfig in row {
                let field = FilterFieldView()
                field.configure(with: fieldConfig)
                rowStack.addArrangedSubview(field)
            }

            filtersContainerStack.addArrangedSubview(rowStack)
        }

        // Optional card
        if config.showsCard {
            containerView.backgroundColor = .systemGray6
            containerView.layer.cornerRadius = 12

            topC.constant = 8
            bottomC.constant = -8
            leadingC.constant = 16
            trailingC.constant = -16
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = 0

            topC.constant = 0
            bottomC.constant = 0
            leadingC.constant = 0
            trailingC.constant = 0
        }
    }
}
