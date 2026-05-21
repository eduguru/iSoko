//
//  OrderConfirmItemCell.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import UIKit

final class OrderConfirmItemCell: UITableViewCell {

    static let reuseIdentifier = "OrderConfirmItemCell"

    private let cardView = UIView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()

    private let stepperView = QuantityStepperView()

    private var viewModel: OrderConfirmItemViewModel?

    // MARK: - Init

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

        // MARK: Card

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)

        // MARK: Labels

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        priceLabel.textColor = .systemGreen

        // MARK: Stepper

        stepperView.translatesAutoresizingMaskIntoConstraints = false

        stepperView.setContentHuggingPriority(.required, for: .horizontal)
        stepperView.setContentCompressionResistancePriority(.required, for: .horizontal)

        // MARK: Labels Stack

        let labelsStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])

        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        labelsStack.alignment = .leading
        labelsStack.translatesAutoresizingMaskIntoConstraints = false

        labelsStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        labelsStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // MARK: Bottom Row

        let bottomRow = UIStackView(arrangedSubviews: [
            priceLabel,
            stepperView
        ])

        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        bottomRow.distribution = .fill
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        // MARK: Main Stack

        let mainStack = UIStackView(arrangedSubviews: [
            labelsStack,
            bottomRow
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStack)

        // MARK: Constraints

        NSLayoutConstraint.activate([

            // Card
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Main Stack
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            // Stepper
            stepperView.widthAnchor.constraint(equalToConstant: 120),
            stepperView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions

    private func setupActions() {

        stepperView.onValueChanged = { [weak self] value in
            guard let self, let vm = self.viewModel else { return }

            vm.updateQuantity(value)
            self.refresh(vm)
        }
    }

    // MARK: - Configure

    func configure(with viewModel: OrderConfirmItemViewModel) {

        self.viewModel = viewModel
        refresh(viewModel)
    }

    // MARK: - Refresh

    private func refresh(_ vm: OrderConfirmItemViewModel) {

        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
        priceLabel.text = vm.formattedTotal

        if stepperView.value != vm.quantity {
            stepperView.value = vm.quantity
        }
    }
}
