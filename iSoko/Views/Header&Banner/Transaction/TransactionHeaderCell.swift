//
//  TransactionHeaderCell.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

final class TransactionHeaderCell: UITableViewCell {

    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let titleIconView = UIImageView()
    private let statusPill = StatusPillView()

    private let headerStack = UIStackView()
    private let columnsStack = UIStackView()
    private let leftStack = UIStackView()
    private let rightStack = UIStackView()
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

        titleIconView.contentMode = .scaleAspectFit
        titleIconView.setContentHuggingPriority(.required, for: .horizontal)

        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center

        headerStack.addArrangedSubview(titleIconView)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(statusPill)

        leftStack.axis = .vertical
        leftStack.spacing = 12

        rightStack.axis = .vertical
        rightStack.spacing = 12

        columnsStack.axis = .horizontal
        columnsStack.spacing = 24
        columnsStack.distribution = .fillEqually
        columnsStack.addArrangedSubview(leftStack)
        columnsStack.addArrangedSubview(rightStack)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(headerStack)
        contentStack.addArrangedSubview(columnsStack)

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

    func configure(with config: TransactionHeaderCellConfig) {
        titleLabel.text = config.title
        titleIconView.image = config.titleIcon
        titleIconView.isHidden = config.titleIcon == nil

        statusPill.configure(
            text: config.statusText,
            textColor: config.statusTextColor,
            backgroundColor: config.statusBackgroundColor
        )

        leftStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        config.leftColumn.forEach {
            let view = IconValueRowView()
            view.configure(icon: $0.icon, text: $0.text)
            leftStack.addArrangedSubview(view)
        }

        config.rightColumn.forEach {
            let view = IconValueRowView()
            view.configure(icon: $0.icon, text: $0.text)
            rightStack.addArrangedSubview(view)
        }

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
