//
//  OrderConfirmItemViewModel.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//
import Foundation

final class OrderConfirmItemViewModel {

    let id: Int
    let title: String
    let subtitle: String
    let currency: String
    let pricePerUnit: Decimal

    private(set) var quantity: Int {
        didSet { onUpdate?(self) }
    }

    private let minimumQuantity: Int
    private let onUpdate: ((OrderConfirmItemViewModel) -> Void)?
    private let onDelete: ((OrderConfirmItemViewModel) -> Void)?

    init(
        id: Int,
        title: String,
        subtitle: String,
        currency: String,
        pricePerUnit: Decimal,
        quantity: Int,
        minimumQuantity: Int = 1,
        onUpdate: ((OrderConfirmItemViewModel) -> Void)? = nil,
        onDelete: ((OrderConfirmItemViewModel) -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.pricePerUnit = pricePerUnit
        self.currency = currency
        self.minimumQuantity = minimumQuantity
        self.quantity = max(quantity, minimumQuantity)
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }

    func updateQuantity(_ newValue: Int) {
        quantity = max(minimumQuantity, newValue)
    }

    func delete() {
        onDelete?(self)
    }

    var totalPrice: Decimal {
        pricePerUnit * Decimal(quantity)
    }

    var formattedTotal: String {
        "\(currency) \(totalPrice)"
    }
}
