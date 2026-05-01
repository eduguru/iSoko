//
//  SmartInfoCardCell.swift
//  
//
//  Created by Edwin Weru on 01/05/2026.
//

import UIKit

public final class SmartInfoCardCell: UITableViewCell {

    private let containerView = UIView()

    private let titleIconView = UIImageView()
    private let titleLabel = UILabel()

    private let subtitleLabel = UILabel()

    private let statusContainer = UIView()
    private let statusStack = UIStackView()
    private let statusIcon = UIImageView()
    private let statusLabel = UILabel()

    private let topStack = UIStackView()
    private let contentStack = UIStackView()

    private var itemViews: [IconTextRowView] = []

    private var onPrimary: (() -> Void)?
    private var onSecondary: (() -> Void)?

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

        // Title
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        titleIconView.setContentHuggingPriority(.required, for: .horizontal)

        topStack.axis = .horizontal
        topStack.spacing = 6
        topStack.alignment = .center
        topStack.addArrangedSubview(titleIconView)
        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(UIView())

        // Content
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(topStack)
        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.addArrangedSubview(statusContainer)

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

    // MARK: - Configure

    public func configure(with config: SmartCardConfig) {

        titleLabel.text = config.title
        titleIconView.image = config.titleIcon

        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        onPrimary = config.primaryAction
        onSecondary = config.secondaryAction

        // Clear old items
        itemViews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        itemViews.removeAll()

        // Render based on layout
        switch config.layout {

        case .profile:
            renderProfile(config.items)

        case .summary:
            renderSummary(config)

        case .compact:
            renderCompact(config.items)
        }

        // Status (like your DualCardView)
        if let status = config.status {
            statusLabel.text = status.text
            statusLabel.textColor = status.textColor
            statusContainer.backgroundColor = status.backgroundColor
            statusIcon.image = status.icon
            statusIcon.isHidden = status.icon == nil
            statusContainer.isHidden = false
        } else {
            statusContainer.isHidden = true
        }

        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.layer.borderColor = config.borderColor.cgColor
        containerView.layer.borderWidth = config.borderWidth
    }

    // MARK: - Render modes

    private func renderProfile(_ items: [InfoItem]) {
        for item in items {
            addRow(item)
        }
    }

    private func renderCompact(_ items: [InfoItem]) {
        for item in items.prefix(2) {
            addRow(item)
        }
    }

    private func renderSummary(_ config: SmartCardConfig) {
        // Example: Sale / Expense cards (like your screenshots)
        for item in config.items {
            addRow(item)
        }
    }

    private func addRow(_ item: InfoItem) {
        let row = IconTextRowView()
        row.configure(text: item.text, icon: item.icon)
        applyStyle(row, style: item.style)

        contentStack.addArrangedSubview(row)
        itemViews.append(row)
    }

    private func applyStyle(_ row: IconTextRowView, style: InfoItemStyle) {

    }
}
