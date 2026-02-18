//
//  FiltersCellConfig.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

public struct FiltersCellConfig {

    public let title: String?
    public let rows: [[FilterFieldConfig]]

    public let message: String?
    public let messageColor: UIColor

    public let showsCard: Bool
    public let cardBackgroundColor: UIColor
    public let cardCornerRadius: CGFloat

    public init(
        title: String? = nil,
        rows: [[FilterFieldConfig]],
        message: String? = nil,
        messageColor: UIColor = .secondaryLabel,
        showsCard: Bool = true,
        cardBackgroundColor: UIColor = .systemGray6,
        cardCornerRadius: CGFloat = 12
    ) {
        self.title = title
        self.rows = rows
        self.message = message
        self.messageColor = messageColor
        self.showsCard = showsCard
        self.cardBackgroundColor = cardBackgroundColor
        self.cardCornerRadius = cardCornerRadius
    }
}
