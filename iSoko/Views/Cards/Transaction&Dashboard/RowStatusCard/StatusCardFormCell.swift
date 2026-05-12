//
//  StatusCardFormCell.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import UIKit

public final class StatusCardFormCell: UITableViewCell {

    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let statusLabel = UILabel()
    private let statusContainer = UIView()

    private let leftStack = UIStackView()
    private let mainStack = UIStackView()

    // MARK: Init

    public override init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        // LEFT SIDE
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading
        leftStack.addArrangedSubview(titleLabel)
        leftStack.addArrangedSubview(subtitleLabel)

        // STATUS
        statusLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        statusLabel.textAlignment = .center

        statusContainer.layer.cornerRadius = 10
        statusContainer.layer.masksToBounds = true
        statusContainer.addSubview(statusLabel)

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 6),
            statusLabel.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: -6),
            statusLabel.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor, constant: -12)
        ])

        // MAIN STACK
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        let spacer = UIView()

        mainStack.addArrangedSubview(leftStack)
        mainStack.addArrangedSubview(spacer)
        mainStack.addArrangedSubview(statusContainer)

        containerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: Configure

    public func configure(with model: StatusCardModel) {

        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle

        subtitleLabel.isHidden = model.subtitle == nil

        statusLabel.text = model.statusText

        statusLabel.textColor = model.statusStyle.textColor
        statusContainer.backgroundColor = model.statusStyle.backgroundColor

        statusContainer.layer.borderWidth = model.statusStyle.borderColor == nil ? 0 : 1
        statusContainer.layer.borderColor = model.statusStyle.borderColor?.cgColor

        if let card = model.card {
            containerView.backgroundColor = card.backgroundColor
            containerView.layer.cornerRadius = card.cornerRadius
            containerView.layer.borderWidth = card.borderWidth
            containerView.layer.borderColor = card.borderColor?.cgColor
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 0
        }
    }
}
