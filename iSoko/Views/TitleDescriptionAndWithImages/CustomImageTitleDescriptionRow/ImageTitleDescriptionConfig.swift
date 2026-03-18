
//
//  ImageTitleDescriptionConfig.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public struct ImageTitleDescriptionConfig {

    public enum AccessoryType {
        case none
        case chevron
        case custom(view: UIView)
        case image(image: UIImage)
    }

    public enum ImageStyle {
        case rounded
        case square
    }

    public var image: UIImage?
    public var imageSize: CGSize
    public var imageStyle: ImageStyle

    public var title: String
    public var description: String?

    public var accessoryType: AccessoryType

    public var spacing: CGFloat
    public var contentInsets: UIEdgeInsets

    public var isEnabled: Bool
    public var onTap: (() -> Void)?

    // Card styling
    public var isCardStyleEnabled: Bool
    public var cardCornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    public var cardBorderColor: UIColor
    public var cardBorderWidth: CGFloat

    // ✅ NEW (icon container control)
    public var iconBackgroundColor: UIColor?
    public var iconCornerRadius: CGFloat?

    public init(
        image: UIImage? = nil,
        imageSize: CGSize = CGSize(width: 44, height: 44),
        imageStyle: ImageStyle = .rounded,

        title: String,
        description: String? = nil,

        accessoryType: AccessoryType = .chevron,

        spacing: CGFloat = 12,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),

        isEnabled: Bool = true,
        onTap: (() -> Void)? = nil,

        isCardStyleEnabled: Bool = false,
        cardCornerRadius: CGFloat = 16,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 0,

        iconBackgroundColor: UIColor? = UIColor.systemGray5,
        iconCornerRadius: CGFloat? = nil
    ) {
        self.image = image
        self.imageSize = imageSize
        self.imageStyle = imageStyle
        self.title = title
        self.description = description
        self.accessoryType = accessoryType
        self.spacing = spacing
        self.contentInsets = contentInsets
        self.isEnabled = isEnabled
        self.onTap = onTap

        self.isCardStyleEnabled = isCardStyleEnabled
        self.cardCornerRadius = cardCornerRadius
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth

        self.iconBackgroundColor = iconBackgroundColor
        self.iconCornerRadius = iconCornerRadius
    }
}
