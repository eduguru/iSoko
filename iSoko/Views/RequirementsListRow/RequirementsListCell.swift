//
//  RequirementsListCell.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

import UIKit

public final class RequirementsListCell: UITableViewCell {
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()

    private var config: RequirementsListRowConfig?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    public func configure(with config: RequirementsListRowConfig) {
        self.config = config

        // Clear previous
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        containerView.layoutMargins = config.contentInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = config.contentInsets
        stackView.spacing = config.spacing

        if let title = config.title {
            titleLabel.text = title
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.textColor = config.titleColor
            titleLabel.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel)
        }

        for item in config.items {
            let itemStack = UIStackView()
            itemStack.axis = .horizontal
            itemStack.alignment = .center
            itemStack.spacing = 8

            let icon = UIImageView()
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.contentMode = .scaleAspectFit
            icon.tintColor = item.isSatisfied ? .app(.primary) : .systemGray

            let iconName: String = {
                switch config.selectionStyle {
                case .checkbox:
                    return item.isSatisfied ? "checkmark.square.fill" : "square"
                case .dot:
                    return item.isSatisfied ? "largecircle.fill.circle" : "circle"
                }
            }()
            icon.image = UIImage(systemName: iconName)

            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 20),
                icon.heightAnchor.constraint(equalToConstant: 20)
            ])

            let label = UILabel()
            label.text = item.title
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.textColor = config.itemColor
            label.numberOfLines = 0

            itemStack.addArrangedSubview(icon)
            itemStack.addArrangedSubview(label)

            stackView.addArrangedSubview(itemStack)
        }

        // Card styling
        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.backgroundColor = config.cardBackgroundColor
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor?.cgColor
            containerView.layer.masksToBounds = true
        } else {
            containerView.layer.cornerRadius = 0
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = nil
        }
    }
}
