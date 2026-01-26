//
//  TransactionActionsCellConfig.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

public struct TransactionActionsCellConfig {

    public let title: String
    public let subtitle: String?

    public let amount: String
    public let amountColor: UIColor

    public let status: String
    public let statusColor: UIColor

    public let primaryAction: ActionCardConfig?
    public let secondaryAction: InlineActionConfig?

    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat

    public init(
        title: String,
        subtitle: String? = nil,
        amount: String,
        amountColor: UIColor = .label,
        status: String,
        statusColor: UIColor = .secondaryLabel,
        primaryAction: ActionCardConfig? = nil,
        secondaryAction: InlineActionConfig? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 12
    ) {
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.amountColor = amountColor
        self.status = status
        self.statusColor = statusColor
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
    }
}
