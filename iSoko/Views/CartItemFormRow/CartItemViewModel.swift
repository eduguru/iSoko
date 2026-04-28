//
//  CartItemViewModel.swift
//  
//
//  Created by Edwin Weru on 04/03/2026.
//

import Foundation

final class CartItemViewModel {

    let id: Int
    let title: String
    let subtitle: String
    let pricePerUnit: Decimal

    private(set) var quantity: Int {
        didSet { onUpdate?(self) }
    }

    private let onUpdate: ((CartItemViewModel) -> Void)?
    private let onDelete: ((CartItemViewModel) -> Void)?

    init(
        id: Int,
        title: String,
        subtitle: String,
        pricePerUnit: Decimal,
        quantity: Int,
        onUpdate: ((CartItemViewModel) -> Void)? = nil,
        onDelete: ((CartItemViewModel) -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.pricePerUnit = pricePerUnit
        self.quantity = max(1, quantity)
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }

    func updateQuantity(_ newValue: Int) {
        quantity = max(1, newValue)
    }

    func delete() {
        onDelete?(self)
    }

    var totalPrice: Decimal {
        pricePerUnit * Decimal(quantity)
    }

    var formattedTotal: String {
        "Ksh. \(totalPrice)"
    }
}
