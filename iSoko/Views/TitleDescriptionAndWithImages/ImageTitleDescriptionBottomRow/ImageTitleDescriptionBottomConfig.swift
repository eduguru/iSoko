//
//  ImageTitleDescriptionBottomConfig.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

// MARK: - Config
public struct ImageTitleDescriptionBottomConfig {
    public enum BottomButtonStyle {
        case primary
        case secondary
        case plain
        case custom(backgroundColor: UIColor, textColor: UIColor)
    }

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
    public var imageStyle: ImageStyle
    public var title: String
    public var description: String?

    // Bottom content
    public var bottomLabelText: String?
    public var bottomButtonTitle: String?
    public var bottomButtonStyle: BottomButtonStyle
    public var onBottomButtonTap: (() -> Void)? // ✅ separate callback

    // Accessory
    public var accessoryType: AccessoryType?

    // Layout
    public var spacing: CGFloat
    public var contentInsets: UIEdgeInsets
    public var isEnabled: Bool
    public var onTap: (() -> Void)?

    // Card style
    public var isCardStyleEnabled: Bool
    public var cardCornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    public var cardBorderColor: UIColor
    public var cardBorderWidth: CGFloat

    public init(
        image: UIImage? = nil,
        imageStyle: ImageStyle = .rounded,
        title: String,
        description: String? = nil,
        bottomLabelText: String? = nil,
        bottomButtonTitle: String? = nil,
        bottomButtonStyle: BottomButtonStyle = .plain,
        onBottomButtonTap: (() -> Void)? = nil,
        accessoryType: AccessoryType? = .chevron,
        spacing: CGFloat = 12,
        contentInsets: UIEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16),
        isEnabled: Bool = true,
        onTap: (() -> Void)? = nil,
        isCardStyleEnabled: Bool = false,
        cardCornerRadius: CGFloat = 12,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1
    ) {
        self.image = image
        self.imageStyle = imageStyle
        self.title = title
        self.description = description
        self.bottomLabelText = bottomLabelText
        self.bottomButtonTitle = bottomButtonTitle
        self.bottomButtonStyle = bottomButtonStyle
        self.onBottomButtonTap = onBottomButtonTap
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
    }
}
