//
//  DropdownFormConfig.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit

public struct DropdownFormConfig {
    public var title: String?
    public var showTitle: Bool        // if false, hide title
    public var placeholder: String
    public var value: String?
    public var subtitle: String?       // used for error / message below

    public var titleFont: UIFont
    public var titleColor: UIColor
    public var subtitleFont: UIFont
    public var subtitleColor: UIColor

    public var leftImage: UIImage?
    public var rightImage: UIImage?

    public var isCardStyleEnabled: Bool
    public var cardCornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    public var cardBorderColor: UIColor
    public var cardBorderWidth: CGFloat

    public var isEnabled: Bool
    public var showAsterisk: Bool

    public var onTap: (() -> Void)?

    public init(
        title: String? = nil,
        showTitle: Bool = true,
        placeholder: String,
        value: String? = nil,
        subtitle: String? = nil,
        titleFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline),
        titleColor: UIColor = .label,
        subtitleFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote),
        subtitleColor: UIColor = .secondaryLabel,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil,
        isCardStyleEnabled: Bool = true,
        cardCornerRadius: CGFloat = 12,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .separator,
        cardBorderWidth: CGFloat = 1,
        isEnabled: Bool = true,
        showAsterisk: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.showTitle = showTitle
        self.placeholder = placeholder
        self.value = value
        self.subtitle = subtitle
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.subtitleFont = subtitleFont
        self.subtitleColor = subtitleColor
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isCardStyleEnabled = isCardStyleEnabled
        self.cardCornerRadius = cardCornerRadius
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.isEnabled = isEnabled
        self.showAsterisk = showAsterisk
        self.onTap = onTap
    }
}
