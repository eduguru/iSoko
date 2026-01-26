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
    private let filtersRow = UIStackView()
    private let contentStack = UIStackView()

    private let leftFilterView = FilterFieldView()
    private let rightFilterView = FilterFieldView()

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

        filtersRow.axis = .horizontal
        filtersRow.spacing = 12
        filtersRow.distribution = .fillEqually

        filtersRow.addArrangedSubview(leftFilterView)
        filtersRow.addArrangedSubview(rightFilterView)

        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(filtersRow)
        contentStack.addArrangedSubview(messageLabel)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentStack)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    public func configure(with config: FiltersCellConfig) {

        titleLabel.text = config.title
        titleLabel.isHidden = config.title == nil

        leftFilterView.configure(with: config.leftFilter)

        if config.layout == .double, let right = config.rightFilter {
            rightFilterView.configure(with: right)
            rightFilterView.isHidden = false
            filtersRow.distribution = .fillEqually
        } else {
            rightFilterView.isHidden = true
            filtersRow.distribution = .fill
        }

        messageLabel.text = config.message
        messageLabel.textColor = config.messageColor
        messageLabel.isHidden = config.message == nil

        if config.showsCard {
            containerView.backgroundColor = config.cardBackgroundColor
            containerView.layer.cornerRadius = config.cardCornerRadius
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = 0
        }
    }

}
