//
//  OrderItemCell.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

// MARK: - Order Item Cell

public final class OrderItemCell: UITableViewCell {

    private let containerView = UIView()

    private let customerNameLabel = UILabel()
    private let orderNumberLabel = UILabel()
    private let dateLabel = UILabel()

    private let statusContainerView = UIView()
    private let statusLabel = UILabel()

    private let amountLabel = UILabel()

    private let separatorView = UIView()

    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let productQuantityLabel = UILabel()
    private let productAmountLabel = UILabel()

    private let productInfoStack = UIStackView()

    private let actionsRowView = ActionsRowView()

    override public init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
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

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 18
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        setupHeader()
        setupProductSection()
        setupActions()
    }

    // MARK: - Header

    private func setupHeader() {

        customerNameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        customerNameLabel.textColor = .darkGray
        customerNameLabel.numberOfLines = 0

        orderNumberLabel.font = .systemFont(ofSize: 17, weight: .bold)
        orderNumberLabel.textColor = .black
        orderNumberLabel.numberOfLines = 0

        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 0

        statusContainerView.layer.cornerRadius = 16
        statusContainerView.layer.borderWidth = 1

        statusContainerView.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        statusLabel.font = .systemFont(ofSize: 14, weight: .bold)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 1

        statusLabel.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )

        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        statusContainerView.addSubview(statusLabel)

        NSLayoutConstraint.activate([

            statusLabel.topAnchor.constraint(
                equalTo: statusContainerView.topAnchor,
                constant: 6
            ),

            statusLabel.bottomAnchor.constraint(
                equalTo: statusContainerView.bottomAnchor,
                constant: -6
            ),

            statusLabel.leadingAnchor.constraint(
                equalTo: statusContainerView.leadingAnchor,
                constant: 12
            ),

            statusLabel.trailingAnchor.constraint(
                equalTo: statusContainerView.trailingAnchor,
                constant: -12
            )
        ])

        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textAlignment = .right
        amountLabel.numberOfLines = 0

        let leftStack = UIStackView(arrangedSubviews: [
            customerNameLabel,
            orderNumberLabel,
            dateLabel
        ])

        leftStack.axis = .vertical
        leftStack.spacing = 6

        leftStack.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )

        let rightStack = UIStackView(arrangedSubviews: [
            statusContainerView,
            amountLabel
        ])

        rightStack.axis = .vertical
        rightStack.spacing = 16
        rightStack.alignment = .fill

        rightStack.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )

        let topStack = UIStackView(arrangedSubviews: [
            leftStack,
            UIView(),
            rightStack
        ])

        topStack.axis = .horizontal
        topStack.alignment = .top
        topStack.spacing = 12
        topStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(topStack)

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            topStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            topStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])

        separatorView.backgroundColor = UIColor.systemGray5
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Product Section

    private func setupProductSection() {

        productImageView.layer.cornerRadius = 12
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 72),
            productImageView.heightAnchor.constraint(equalToConstant: 72)
        ])

        productNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        productNameLabel.textColor = .black
        productNameLabel.numberOfLines = 2

        productQuantityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        productQuantityLabel.textColor = .gray
        productQuantityLabel.numberOfLines = 0

        let labelsStack = UIStackView(arrangedSubviews: [
            productNameLabel,
            productQuantityLabel
        ])

        labelsStack.axis = .vertical
        labelsStack.spacing = 4

        productAmountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        productAmountLabel.textAlignment = .right
        productAmountLabel.textColor = .darkGray

        productAmountLabel.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )

        productInfoStack.axis = .horizontal
        productInfoStack.spacing = 16
        productInfoStack.alignment = .center
        productInfoStack.translatesAutoresizingMaskIntoConstraints = false

        productInfoStack.addArrangedSubview(productImageView)
        productInfoStack.addArrangedSubview(labelsStack)
        productInfoStack.addArrangedSubview(UIView())
        productInfoStack.addArrangedSubview(productAmountLabel)

        containerView.addSubview(productInfoStack)

        NSLayoutConstraint.activate([
            productInfoStack.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 22),
            productInfoStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            productInfoStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Actions

    private func setupActions() {

        actionsRowView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(actionsRowView)

        NSLayoutConstraint.activate([
            actionsRowView.topAnchor.constraint(equalTo: productInfoStack.bottomAnchor, constant: 24),
            actionsRowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            actionsRowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            actionsRowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Configure

    public func configure(with config: OrderItemCellConfig) {

        customerNameLabel.text = config.customerName
        orderNumberLabel.text = config.orderNumber
        dateLabel.text = config.date

        statusLabel.text = config.status
        statusLabel.textColor = config.statusTextColor

        statusContainerView.layer.borderColor =
            config.statusBorderColor.cgColor

        statusContainerView.backgroundColor =
            config.statusBackgroundColor

        amountLabel.text = config.amount
        amountLabel.textColor = config.amountColor

        productImageView.image = config.productImage

        productNameLabel.text = config.productName

        productQuantityLabel.text =
            config.productQuantityText

        productAmountLabel.text =
            config.productAmount

        actionsRowView.configure(
            actions: config.actions
        )

        actionsRowView.isHidden =
            config.actions.isEmpty
    }
}
