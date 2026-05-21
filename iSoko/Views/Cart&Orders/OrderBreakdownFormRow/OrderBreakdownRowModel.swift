//
//  OrderBreakdownRowModel.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

struct OrderBreakdownRowModel {
    let title: String
    let value: String
    let isHighlighted: Bool

    init(title: String, value: String, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
    }
}

struct OrderBreakdownModel {
    let title: String
    let rows: [OrderBreakdownRowModel]
    let totalTitle: String
    let totalValue: String
}
