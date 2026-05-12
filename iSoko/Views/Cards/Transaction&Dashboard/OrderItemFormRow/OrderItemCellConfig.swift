//
//  OrderItemCellConfig.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

// MARK: - Order Item Cell Config

public struct OrderItemCellConfig {

    public let customerName: String
    public let orderNumber: String
    public let date: String

    public let status: String
    public let statusTextColor: UIColor
    public let statusBorderColor: UIColor
    public let statusBackgroundColor: UIColor

    public let amount: String
    public let amountColor: UIColor

    public let productImage: UIImage?
    public let productName: String
    public let productQuantityText: String
    public let productAmount: String

    public let actions: [ActionButtonConfig]

    public init(
        customerName: String,
        orderNumber: String,
        date: String,
        status: String,
        statusTextColor: UIColor,
        statusBorderColor: UIColor,
        statusBackgroundColor: UIColor,
        amount: String,
        amountColor: UIColor,
        productImage: UIImage?,
        productName: String,
        productQuantityText: String,
        productAmount: String,
        actions: [ActionButtonConfig]
    ) {
        self.customerName = customerName
        self.orderNumber = orderNumber
        self.date = date

        self.status = status
        self.statusTextColor = statusTextColor
        self.statusBorderColor = statusBorderColor
        self.statusBackgroundColor = statusBackgroundColor

        self.amount = amount
        self.amountColor = amountColor

        self.productImage = productImage
        self.productName = productName
        self.productQuantityText = productQuantityText
        self.productAmount = productAmount

        self.actions = actions
    }
}

