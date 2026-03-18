//
//  CartItemCell.swift
//  
//
//  Created by Edwin Weru on 04/03/2026.
//

import UIKit

final class CartItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: CartItemCell.self)

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

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear

        // MARK: - Card View
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // MARK: - Top Row
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        priceLabel.textAlignment = .right
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let topRow = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        topRow.axis = .horizontal
        topRow.distribution = .fill
        topRow.alignment = .center
        topRow.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(topRow)

        // MARK: - Description
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)

        // MARK: - Bottom Row
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        stepperView.translatesAutoresizingMaskIntoConstraints = false
        amountView.translatesAutoresizingMaskIntoConstraints = false

        let bottomRow = UIStackView(arrangedSubviews: [stepperView, amountView])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.alignment = .center
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomRow)
        bottomContainer.addSubview(deleteButton)

        // MARK: - Constraints
        NSLayoutConstraint.activate([
            // Card edges
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Top row
            topRow.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            topRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            topRow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            // Bottom row container
            bottomContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            bottomContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            // Bottom row
            bottomRow.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 12),
            bottomRow.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),

            // Delete button
            deleteButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28),

            // Fixed widths
            stepperView.widthAnchor.constraint(equalToConstant: 120),
            amountView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupActions() {
        // Stepper
        stepperView.onValueChanged = { [weak self] value in
            guard let self = self else { return }
            print("🔥 Stepper tapped, value: \(value)")
            self.viewModel?.updateQuantity(value)
        }

        // Delete button
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    func configure(with viewModel: CartItemViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        priceLabel.text = viewModel.formattedTotal
        stepperView.value = viewModel.quantity
        amountView.setAmount(viewModel.formattedTotal)

        // Update UI on ViewModel changes
        viewModel.onUpdate = { [weak self] vm in
            guard let self = self else { return }
            print("💠 ViewModel updated quantity to \(vm.quantity)")

            self.priceLabel.text = vm.formattedTotal
            self.amountView.setAmount(vm.formattedTotal)

            // Only update stepper if different to avoid loops
            if self.stepperView.value != vm.quantity {
                self.stepperView.value = vm.quantity
            }
        }

        viewModel.onDelete = { vm in
            print("💥 Delete tapped for \(vm.title)")
        }
    }

    @objc private func deleteTapped() {
        viewModel?.delete()
    }
}
