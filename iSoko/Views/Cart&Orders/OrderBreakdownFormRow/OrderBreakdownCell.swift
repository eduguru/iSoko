//
//  OrderBreakdownCell.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import UIKit

final class OrderBreakdownCell: UITableViewCell {

    static let reuseIdentifier = "OrderBreakdownCell"

    // MARK: UI

    private let cardView = UIView()
    private let titleLabel = UILabel()

    private let stackView = UIStackView()

    private let totalContainer = UIStackView()
    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()

    private var dynamicRows: [UIStackView] = []

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Setup

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear

        // Card
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)

        // Title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label

        // Stack
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stackView)

        // Total
        totalTitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        totalTitleLabel.textColor = .label

        totalValueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        totalValueLabel.textColor = .systemGreen
        totalValueLabel.textAlignment = .right

        totalContainer.axis = .horizontal
        totalContainer.distribution = .fillEqually
        totalContainer.addArrangedSubview(totalTitleLabel)
        totalContainer.addArrangedSubview(totalValueLabel)

        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: Configure

    func configure(with model: OrderBreakdownModel) {

        titleLabel.text = model.title

        // remove old rows
        dynamicRows.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        dynamicRows.removeAll()

        // add rows
        for row in model.rows {

            let left = UILabel()
            left.font = .systemFont(ofSize: 14)
            left.textColor = .secondaryLabel
            left.text = row.title

            let right = UILabel()
            right.font = .systemFont(ofSize: 14, weight: .medium)
            right.textColor = row.isHighlighted ? .systemGreen : .label
            right.textAlignment = .right
            right.text = row.value

            let rowStack = UIStackView(arrangedSubviews: [left, right])
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually

            stackView.addArrangedSubview(rowStack)
            dynamicRows.append(rowStack)
        }

        // ensure total row exists
        if totalContainer.superview == nil {
            stackView.addArrangedSubview(totalContainer)
        }

        totalTitleLabel.text = model.totalTitle
        totalValueLabel.text = model.totalValue
    }
}
