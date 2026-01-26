//
//  FiltersCellConfig.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

public struct FiltersCellConfig {

    public let title: String?

    public let layout: FiltersLayout
    public let leftFilter: FilterFieldConfig
    public let rightFilter: FilterFieldConfig?

    public let message: String?
    public let messageColor: UIColor

    public let showsCard: Bool
    public let cardBackgroundColor: UIColor
    public let cardCornerRadius: CGFloat

    public init(
        title: String? = nil,
        layout: FiltersLayout = .double,
        leftFilter: FilterFieldConfig,
        rightFilter: FilterFieldConfig? = nil,
        message: String? = nil,
        messageColor: UIColor = .secondaryLabel,
        showsCard: Bool = true,
        cardBackgroundColor: UIColor = .systemGray6,
        cardCornerRadius: CGFloat = 12
    ) {
        self.title = title
        self.layout = layout
        self.leftFilter = leftFilter
        self.rightFilter = rightFilter
        self.message = message
        self.messageColor = messageColor
        self.showsCard = showsCard
        self.cardBackgroundColor = cardBackgroundColor
        self.cardCornerRadius = cardCornerRadius
    }
}
