//
//  ExpenseHeaderCell.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

final class ExpenseHeaderCell: UITableViewCell {

    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let titleIconView = UIImageView()
    private let amountLabel = UILabel()

    private let headerStack = UIStackView()
    private let rowsStack = UIStackView()

    private let footerStack = UIStackView()
    private let dateLabel = UILabel()
    private let paymentPill = StatusPillView()

    private let contentStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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

        titleLabel.font = .preferredFont(forTextStyle: .title3)

        amountLabel.font = .preferredFont(forTextStyle: .title3)
        amountLabel.textColor = .systemRed

        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.addArrangedSubview(titleIconView)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(amountLabel)

        rowsStack.axis = .vertical
        rowsStack.spacing = 12

        footerStack.axis = .horizontal
        footerStack.addArrangedSubview(dateLabel)
        footerStack.addArrangedSubview(UIView())
        footerStack.addArrangedSubview(paymentPill)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(headerStack)
        contentStack.addArrangedSubview(rowsStack)
        contentStack.addArrangedSubview(footerStack)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentStack)
        contentView.addSubview(containerView)

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

    func configure(with config: ExpenseHeaderCellConfig) {
        titleLabel.text = config.title
        titleIconView.image = config.titleIcon
        amountLabel.attributedText = config.amountText

        rowsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        config.rows.forEach {
            let view = IconValueRowView()
            view.configure(icon: $0.icon, text: $0.text)
            rowsStack.addArrangedSubview(view)
        }

        dateLabel.attributedText = config.dateText

        paymentPill.configure(
            text: config.paymentText,
            textColor: config.paymentTextColor,
            backgroundColor: config.paymentBackgroundColor
        )

        containerView.apply(cardStyle: config.cardStyle)
    }

}

private extension UIView {

    func apply(cardStyle: CardStyle) {
        let appearance = cardStyle.appearance()

        backgroundColor = appearance.backgroundColor
        layer.cornerRadius = appearance.cornerRadius

        layer.borderColor = appearance.borderColor?.cgColor
        layer.borderWidth = appearance.borderWidth

        if let shadow = appearance.shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = shadow.opacity
            layer.shadowRadius = shadow.radius
            layer.shadowOffset = shadow.offset
            layer.masksToBounds = false
        } else {
            layer.shadowOpacity = 0
        }
    }
}
