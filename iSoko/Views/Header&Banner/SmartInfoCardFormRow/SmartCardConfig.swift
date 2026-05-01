//
//  SmartCardConfig.swift
//  
//
//  Created by Edwin Weru on 01/05/2026.
//

import UIKit

public struct SmartCardConfig {

    public let title: String
    public let titleIcon: UIImage?

    public let subtitle: String?
    public let status: CardStatusStyle?

    public let items: [InfoItem]

    public let layout: SmartCardLayout

    public let primaryAction: (() -> Void)?
    public let secondaryAction: (() -> Void)?

    public let backgroundColor: UIColor
    public let borderColor: UIColor
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat

    public init(
        title: String,
        titleIcon: UIImage? = nil,
        subtitle: String? = nil,
        status: CardStatusStyle? = nil,
        items: [InfoItem] = [],
        layout: SmartCardLayout = .profile,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        backgroundColor: UIColor = .systemBackground,
        borderColor: UIColor = .systemGray4,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 16
    ) {
        self.title = title
        self.titleIcon = titleIcon
        self.subtitle = subtitle
        self.status = status
        self.items = items
        self.layout = layout
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
}
