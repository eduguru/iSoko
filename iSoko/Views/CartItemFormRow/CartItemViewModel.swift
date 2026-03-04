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

    var onUpdate: ((CartItemViewModel) -> Void)?
    var onDelete: ((CartItemViewModel) -> Void)?

    init(id: Int,
         title: String,
         subtitle: String,
         pricePerUnit: Decimal,
         quantity: Int) {

        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.pricePerUnit = pricePerUnit
        self.quantity = max(1, quantity)
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
