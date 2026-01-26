//
//  TransactionSummaryCellConfig.swift
//  
//
//  Created by Edwin Weru on 25/01/2026.
//

import UIKit

public struct TransactionSummaryCellConfig {

    public let title: String
    public let amount: String
    public let amountColor: UIColor

    public let dateText: String
    public let saleTypeText: String
    public let saleTypeTextColor: UIColor
    public let saleTypeBackgroundColor: UIColor

    public let itemsCountText: String

    public let primaryAction: ActionCardConfig?
    public let secondaryAction: InlineActionConfig?

    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat
    
    public let buttonPadding: CGFloat
    public let actionsTopPadding: CGFloat
    
    public init(
        title: String,
        amount: String,
        amountColor: UIColor = .label,
        dateText: String,
        saleTypeText: String,
        saleTypeTextColor: UIColor = .label,
        saleTypeBackgroundColor: UIColor = .systemGray6,
        itemsCountText: String,
        primaryAction: ActionCardConfig? = nil,
        secondaryAction: InlineActionConfig? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 12,
        buttonPadding: CGFloat = 20,
        actionsTopPadding: CGFloat = 20
    ) {
        self.title = title
        self.amount = amount
        self.amountColor = amountColor
        self.dateText = dateText
        self.saleTypeText = saleTypeText
        self.saleTypeTextColor = saleTypeTextColor
        self.saleTypeBackgroundColor = saleTypeBackgroundColor
        self.itemsCountText = itemsCountText
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
        self.buttonPadding = buttonPadding
        self.actionsTopPadding = actionsTopPadding
    }
}
