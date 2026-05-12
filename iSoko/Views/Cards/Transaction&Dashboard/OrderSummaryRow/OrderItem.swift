//
//  OrderItem.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//


public struct OrderItem {
    public let quantity: Int
    public let name: String
    public let amount: String
    
    public init(quantity: Int, name: String, amount: String) {
        self.quantity = quantity
        self.name = name
        self.amount = amount
    }
}
