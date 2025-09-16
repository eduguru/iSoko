//
//  SelectableRowModel.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit

public struct SelectableRowConfig {
    public enum SelectionStyle {
        case checkbox
        case radio
    }

    public var title: String
    public var description: String?
    public var isSelected: Bool
    public var selectionStyle: SelectionStyle

    public var isEnabled: Bool
    public var isAccessoryVisible: Bool
    public var accessoryImage: UIImage?

    public var isCardStyleEnabled: Bool
    public var cardCornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    public var cardBorderColor: UIColor?
    public var cardBorderWidth: CGFloat

    public var spacing: CGFloat
    public var contentInsets: UIEdgeInsets

    public var onToggle: ((Bool) -> Void)?

    public init(
        title: String,
        description: String? = nil,
        isSelected: Bool = false,
        selectionStyle: SelectionStyle = .checkbox,
        isEnabled: Bool = true,
        isAccessoryVisible: Bool = false,
        accessoryImage: UIImage? = nil,
        isCardStyleEnabled: Bool = false,
        cardCornerRadius: CGFloat = 12,
        cardBackgroundColor: UIColor = .secondarySystemGroupedBackground,
        cardBorderColor: UIColor? = nil,
        cardBorderWidth: CGFloat = 0,
        spacing: CGFloat = 12,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.isSelected = isSelected
        self.selectionStyle = selectionStyle
        self.isEnabled = isEnabled
        self.isAccessoryVisible = isAccessoryVisible
        self.accessoryImage = accessoryImage
        self.isCardStyleEnabled = isCardStyleEnabled
        self.cardCornerRadius = cardCornerRadius
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.spacing = spacing
        self.contentInsets = contentInsets
        self.onToggle = onToggle
    }
}
