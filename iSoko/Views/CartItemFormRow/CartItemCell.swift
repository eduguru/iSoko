//
//  CartItemCell.swift
//  
//
//  Created by Edwin Weru on 04/03/2026.
//

import UIKit

final class CartItemCell: UITableViewCell {

    static let reuseIdentifier = "CartItemCell"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stepperView = QuantityStepperView()
    private let amountView = AmountView()
    private let deleteButton = UIButton(type: .system)

    private var viewModel: CartItemViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }

    // MARK: - UI
    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear

        // MARK: Card View
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // MARK: Labels
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.adjustsFontForContentSizeCategory = true

        priceLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        priceLabel.adjustsFontForContentSizeCategory = true
        priceLabel.textAlignment = .right

        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        // MARK: Top Row
        let topRow = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        topRow.axis = .horizontal
        topRow.distribution = .fill
        topRow.alignment = .center
        topRow.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(topRow)

        // MARK: Bottom Row
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        stepperView.translatesAutoresizingMaskIntoConstraints = false
        amountView.translatesAutoresizingMaskIntoConstraints = false

        // 🔥 FIXED: no more fixed width for amountView
        amountView.setContentHuggingPriority(.required, for: .horizontal)
        amountView.setContentCompressionResistancePriority(.required, for: .horizontal)

        stepperView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stepperView.setContentCompressionResistancePriority(.required, for: .horizontal)

        deleteButton.setContentHuggingPriority(.required, for: .horizontal)

        let bottomRow = UIStackView(arrangedSubviews: [stepperView, amountView])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.alignment = .center
        bottomRow.distribution = .fill
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomRow)
        bottomContainer.addSubview(deleteButton)

        cardView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: Constraints
        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            topRow.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            topRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            topRow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            descriptionLabel.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            bottomContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            bottomContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            bottomRow.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 12),
            bottomRow.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),

            deleteButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    // MARK: - Actions
    private func setupActions() {

        stepperView.onValueChanged = { [weak self] value in
            guard let self, let vm = self.viewModel else { return }

            vm.updateQuantity(value)
            self.refreshUI(from: vm)
        }

        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    @objc private func deleteTapped() {
        viewModel?.delete()
    }

    // MARK: - Config
    func configure(with viewModel: CartItemViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle

        refreshUI(from: viewModel)
    }

    // MARK: - Local UI Sync
    private func refreshUI(from viewModel: CartItemViewModel) {

        priceLabel.text = viewModel.formattedTotal
        amountView.setAmount(viewModel.formattedTotal)

        if stepperView.value != viewModel.quantity {
            stepperView.value = viewModel.quantity
        }
    }
}
