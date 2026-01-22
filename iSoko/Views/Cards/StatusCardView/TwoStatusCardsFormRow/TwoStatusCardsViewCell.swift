//
//  TwoStatusCardsViewCell.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import UIKit

final class TwoStatusCardsViewCell: UITableViewCell {

    // Header
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // Cards
    private let stackView = UIStackView()
    private let firstCard = StatusCardView()
    private let secondCard = StatusCardView()

    // Root stack
    private let rootStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Root stack
        rootStack.axis = .vertical
        rootStack.spacing = 8
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rootStack)

        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        // Title
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label

        // Description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel

        // Cards stack
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12

        stackView.addArrangedSubview(firstCard)
        stackView.addArrangedSubview(secondCard)

        // Order matters
        rootStack.addArrangedSubview(titleLabel)
        rootStack.addArrangedSubview(descriptionLabel)
        rootStack.addArrangedSubview(stackView)
    }

    // Existing usage (unchanged)
    func configure(with model: TwoStatusCardsViewModel) {
        applyHeader(title: nil, description: nil)
        applyCards(model)
    }

    // NEW usage
    func configure(with summary: TwoCardsSummaryViewModel) {
        applyHeader(title: summary.title, description: summary.description)
        applyCards(summary.cards)
    }

    private func applyHeader(title: String?, description: String?) {
        titleLabel.text = title
        titleLabel.isHidden = title == nil

        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil

        // Remove spacing if both hidden
        let hasHeader = title != nil || description != nil
        rootStack.setCustomSpacing(hasHeader ? 8 : 0, after: descriptionLabel)
    }

    private func applyCards(_ model: TwoStatusCardsViewModel) {
        stackView.axis = model.layout == .horizontal ? .horizontal : .vertical
        stackView.spacing = model.spacing
        stackView.distribution = model.layout == .vertical ? .fill : .fillEqually

        if let first = model.first {
            firstCard.isHidden = false
            firstCard.configure(with: first)
        } else {
            firstCard.isHidden = true
        }

        if let second = model.second {
            secondCard.isHidden = false
            secondCard.configure(with: second)
        } else {
            secondCard.isHidden = true
        }
    }
}
