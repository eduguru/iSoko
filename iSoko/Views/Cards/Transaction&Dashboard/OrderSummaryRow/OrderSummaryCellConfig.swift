//
//  OrderSummaryCellConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit


public struct OrderSummaryCellConfig {
    public let orderTitle: String
    public let orderTitleFont: UIFont
    public let orderTitleColor: UIColor
    
    public let amount: String
    public let amountColor: UIColor
    public let amountFont: UIFont
    
    public let dateString: String
    public let itemCountString: String
    public let subtitleColor: UIColor
    public let subtitleFont: UIFont
    
    public let statusText: String
    public let statusTextColor: UIColor
    public let statusBackgroundColor: UIColor
    public let statusCornerRadius: CGFloat
    
    public let items: [OrderItem]
    public let itemFont: UIFont
    public let itemAmountFont: UIFont
    
    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat
    
    public init(
        orderTitle: String,
        orderTitleFont: UIFont = .preferredFont(forTextStyle: .headline),
        orderTitleColor: UIColor = .label,
        amount: String,
        amountColor: UIColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1), // green
        amountFont: UIFont = .preferredFont(forTextStyle: .headline),
        dateString: String,
        itemCountString: String,
        subtitleColor: UIColor = .secondaryLabel,
        subtitleFont: UIFont = .preferredFont(forTextStyle: .subheadline),
        statusText: String,
        statusTextColor: UIColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1),
        statusBackgroundColor: UIColor = UIColor(red: 0.85, green: 1, blue: 0.85, alpha: 1),
        statusCornerRadius: CGFloat = 12,
        items: [OrderItem],
        itemFont: UIFont = .preferredFont(forTextStyle: .body),
        itemAmountFont: UIFont = .preferredFont(forTextStyle: .body),
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = UIColor.systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 16
    ) {
        self.orderTitle = orderTitle
        self.orderTitleFont = orderTitleFont
        self.orderTitleColor = orderTitleColor
        self.amount = amount
        self.amountColor = amountColor
        self.amountFont = amountFont
        self.dateString = dateString
        self.itemCountString = itemCountString
        self.subtitleColor = subtitleColor
        self.subtitleFont = subtitleFont
        self.statusText = statusText
        self.statusTextColor = statusTextColor
        self.statusBackgroundColor = statusBackgroundColor
        self.statusCornerRadius = statusCornerRadius
        self.items = items
        self.itemFont = itemFont
        self.itemAmountFont = itemAmountFont
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
    }
}
