//
//  StatsCardItem.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit

public struct StatsCardItem {
    public let id: String
    public let icon: UIImage?
    public let title: String
    public let value: String
    public let iconBackgroundColor: UIColor?
    public let backgroundColor: UIColor?    // fallback if cardSettings.backgroundColor is nil
    public let cardSettings: CardSettings?  // optional per-item card appearance
    public let onTap: (() -> Void)?

    public init(
        id: String,
        icon: UIImage?,
        title: String,
        value: String,
        iconBackgroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        cardSettings: CardSettings? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.value = value
        self.iconBackgroundColor = iconBackgroundColor
        self.backgroundColor = backgroundColor
        self.cardSettings = cardSettings
        self.onTap = onTap
    }
}
