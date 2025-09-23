//
//  RequirementsListRowConfig.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

import UIKit

public struct RequirementsListRowConfig {
    public enum SelectionStyle {
        case checkbox
        case dot
    }

    public var title: String?
    public var items: [RequirementItem]

    public var titleColor: UIColor
    public var itemColor: UIColor
    public var selectionStyle: SelectionStyle

    public var isCardStyleEnabled: Bool
    public var cardCornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    public var cardBorderColor: UIColor?
    public var cardBorderWidth: CGFloat

    public var spacing: CGFloat
    public var contentInsets: UIEdgeInsets

    public init(
        title: String? = nil,
        items: [RequirementItem],
        titleColor: UIColor = .label,
        itemColor: UIColor = .secondaryLabel,
        selectionStyle: SelectionStyle = .checkbox,
        isCardStyleEnabled: Bool = false,
        cardCornerRadius: CGFloat = 12,
        cardBackgroundColor: UIColor = .secondarySystemGroupedBackground,
        cardBorderColor: UIColor? = nil,
        cardBorderWidth: CGFloat = 0,
        spacing: CGFloat = 8,
        contentInsets: UIEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
    ) {
        self.title = title
        self.items = items
        self.titleColor = titleColor
        self.itemColor = itemColor
        self.selectionStyle = selectionStyle
        self.isCardStyleEnabled = isCardStyleEnabled
        self.cardCornerRadius = cardCornerRadius
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.spacing = spacing
        self.contentInsets = contentInsets
    }
}
