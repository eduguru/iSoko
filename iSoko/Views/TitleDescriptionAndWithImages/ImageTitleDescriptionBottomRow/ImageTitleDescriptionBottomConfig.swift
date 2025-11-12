//
//  ImageTitleDescriptionBottomConfig.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit


// MARK: - Config
public struct ImageTitleDescriptionBottomConfig {
    public var image: UIImage?
    public var imageStyle: ImageTitleDescriptionConfig.ImageStyle
    public var title: String
    public var description: String?

    // Bottom optional content
    public var bottomLabelText: String?
    public var bottomButtonTitle: String?

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
        imageStyle: ImageTitleDescriptionConfig.ImageStyle = .rounded,
        title: String,
        description: String? = nil,
        bottomLabelText: String? = nil,
        bottomButtonTitle: String? = nil,
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
