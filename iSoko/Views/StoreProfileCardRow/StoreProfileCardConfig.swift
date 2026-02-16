//
//  StoreProfileCardConfig.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit

public struct StoreProfileCardConfig {

    public struct Action {
        public let title: String
        public let image: UIImage?
        public let handler: (() -> Void)?

        public init(
            title: String,
            image: UIImage?,
            handler: (() -> Void)? = nil
        ) {
            self.title = title
            self.image = image
            self.handler = handler
        }
    }

    public var image: UIImage?
    public var title: String

    // Verified badge image (optional)
    public var verifiedImage: UIImage?

    // Reusable badge pills (uses your BadgeView)
    public var badges: [(text: String, textColor: UIColor, backgroundColor: UIColor)]

    // Trailing button
    public var trailingButtonTitle: String?
    public var onTrailingButtonTap: (() -> Void)?

    // Bottom actions
    public var actions: [Action]

    // Card styling
    public var cornerRadius: CGFloat
    public var backgroundColor: UIColor
    public var borderColor: UIColor
    public var borderWidth: CGFloat

    public init(
        image: UIImage?,
        title: String,
        verifiedImage: UIImage? = nil,
        badges: [(String, UIColor, UIColor)] = [],
        trailingButtonTitle: String? = nil,
        onTrailingButtonTap: (() -> Void)? = nil,
        actions: [Action] = [],
        cornerRadius: CGFloat = 16,
        backgroundColor: UIColor = .systemBackground,
        borderColor: UIColor = .systemGray5,
        borderWidth: CGFloat = 1
    ) {
        self.image = image
        self.title = title
        self.verifiedImage = verifiedImage
        self.badges = badges
        self.trailingButtonTitle = trailingButtonTitle
        self.onTrailingButtonTap = onTrailingButtonTap
        self.actions = actions
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}
