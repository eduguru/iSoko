//
//  TransactionSummaryCell.swift
//  
//
//  Created by Edwin Weru on 25/01/2026.
//

import UIKit

public final class TransactionSummaryCell: UITableViewCell {

    private let containerView = UIView()

    private let dateLabel = UILabel()
    private let dotView = UIView()
    private let saleTypeBadge = BadgeView()
    private let itemsCountLabel = UILabel()

    private let titleLabel = UILabel()
    private let amountLabel = UILabel()

    private let primaryActionView = ActionCardView()
    private let secondaryActionView = InlineActionButton()

    private let topRow = UIStackView()
    private let secondRow = UIStackView()
    private let actionsRow = UIStackView()
    private let contentStack = UIStackView()
    
    public let actionsTopPadding: CGFloat = 20

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

        amountLabel.font = .preferredFont(forTextStyle: .body)
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)

        // MARK: Rows

        topRow.axis = .horizontal
        topRow.addArrangedSubview(titleLabel)
        topRow.addArrangedSubview(UIView())
        topRow.addArrangedSubview(amountLabel)

        secondRow.axis = .horizontal
        secondRow.spacing = 6
        secondRow.alignment = .center
        secondRow.addArrangedSubview(dateLabel)
        secondRow.addArrangedSubview(dotView)
        secondRow.addArrangedSubview(saleTypeBadge)
        secondRow.addArrangedSubview(UIView())
        secondRow.addArrangedSubview(itemsCountLabel)

        actionsRow.axis = .horizontal
        actionsRow.alignment = .center
        actionsRow.spacing = 12

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

        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = .secondaryLabel
        dotView.layer.cornerRadius = 2
        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 4),
            dotView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    public func configure(with config: TransactionSummaryCellConfig) {
        titleLabel.text = config.title
        amountLabel.text = config.amount
        amountLabel.textColor = config.amountColor

        dateLabel.text = config.dateText
        saleTypeBadge.configure(
            text: config.saleTypeText,
            textColor: config.saleTypeTextColor,
            backgroundColor: config.saleTypeBackgroundColor
        )
        itemsCountLabel.text = config.itemsCountText

        // Horizontal spacing between buttons
        actionsRow.spacing = config.buttonPadding

        // 🔑 Vertical spacing ABOVE actions row
        contentStack.setCustomSpacing(
            config.actionsTopPadding,
            after: secondRow
        )

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

        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderColor = config.cardBorderColor.cgColor
        containerView.layer.borderWidth = config.cardBorderWidth
    }
}
