//
//  TransactionActionsCell.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public final class TransactionActionsCell: UITableViewCell {

    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let amountLabel = UILabel()
    private let statusLabel = UILabel()

    private let primaryActionView = ActionCardView()
    private let secondaryActionView = InlineActionButton()

    private let topRow = UIStackView()
    private let secondRow = UIStackView()
    private let actionsRow = UIStackView()
    private let contentStack = UIStackView()

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

        titleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel

        amountLabel.font = .preferredFont(forTextStyle: .body)
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)

        statusLabel.font = .preferredFont(forTextStyle: .subheadline)
        statusLabel.textAlignment = .right

        topRow.axis = .horizontal
        topRow.addArrangedSubview(titleLabel)
        topRow.addArrangedSubview(UIView())
        topRow.addArrangedSubview(amountLabel)

        secondRow.axis = .horizontal
        secondRow.addArrangedSubview(subtitleLabel)
        secondRow.addArrangedSubview(UIView())
        secondRow.addArrangedSubview(statusLabel)

        actionsRow.axis = .horizontal
        actionsRow.spacing = 12
        actionsRow.alignment = .center
        actionsRow.addArrangedSubview(primaryActionView)
        actionsRow.addArrangedSubview(UIView())
        actionsRow.addArrangedSubview(secondaryActionView)

        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(topRow)
        contentStack.addArrangedSubview(secondRow)
        contentStack.addArrangedSubview(actionsRow)

        containerView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }

    public func configure(with config: TransactionActionsCellConfig) {
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        amountLabel.text = config.amount
        amountLabel.textColor = config.amountColor

        statusLabel.text = config.status
        statusLabel.textColor = config.statusColor

        if let primary = config.primaryAction {
            primaryActionView.configure(with: primary)
            primaryActionView.isHidden = false
        } else {
            primaryActionView.isHidden = true
        }

        if let secondary = config.secondaryAction {
            secondaryActionView.configure(with: secondary)
            secondaryActionView.isHidden = false
        } else {
            secondaryActionView.isHidden = true
        }

        actionsRow.isHidden =
            config.primaryAction == nil &&
            config.secondaryAction == nil

        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderColor = config.cardBorderColor.cgColor
        containerView.layer.borderWidth = config.cardBorderWidth
    }
}
