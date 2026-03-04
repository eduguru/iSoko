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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
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
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        stepperView.translatesAutoresizingMaskIntoConstraints = false
        amountView.translatesAutoresizingMaskIntoConstraints = false

        let bottomRow = UIStackView(arrangedSubviews: [stepperView, amountView])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.alignment = .center
        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(bottomRow)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(container)
        container.addSubview(bottomRow)
        container.addSubview(deleteButton)

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
            bottomRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            bottomRow.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            bottomRow.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            // Delete button
            deleteButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),

            // Fixed widths
            stepperView.widthAnchor.constraint(equalToConstant: 120),
            amountView.widthAnchor.constraint(equalToConstant: 100)
        ])

        // Stepper callback
        stepperView.onValueChanged = { [weak self] value in
            self?.viewModel?.updateQuantity(value)
        }
    }
    
    func configure(with viewModel: CartItemViewModel) {
        self.viewModel = viewModel

        // Set UI
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        priceLabel.text = viewModel.formattedTotal
        stepperView.value = viewModel.quantity
        amountView.setAmount(viewModel.formattedTotal)

        // MARK: - Stepper callback
        stepperView.onValueChanged = { [weak self] value in
            // This is the ONLY place user taps propagate to the view model
            self?.viewModel?.updateQuantity(value)
        }

        // MARK: - ViewModel updates
        viewModel.onUpdate = { [weak self] vm in
            guard let self = self else { return }

            self.priceLabel.text = vm.formattedTotal
            self.amountView.setAmount(vm.formattedTotal)

            // Update stepper if it differs
            if self.stepperView.value != vm.quantity {
                self.stepperView.value = vm.quantity
            }
        }
    }
    
    @objc private func deleteTapped() {
        viewModel?.delete()
    }
}
