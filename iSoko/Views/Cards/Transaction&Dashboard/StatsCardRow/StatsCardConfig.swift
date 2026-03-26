//
//  StatsCardConfig.swift
//  
//
//  Created by Edwin Weru on 26/03/2026.
//

import UIKit

public struct StatsCardConfig {

    public struct Item {
        public let id: String
        public let icon: UIImage?
        public let title: String
        public let value: String
        public let iconBackgroundColor: UIColor?
        public let backgroundColor: UIColor?
        public let onTap: (() -> Void)?

        public init(
            id: String,
            icon: UIImage?,
            title: String,
            value: String,
            iconBackgroundColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            onTap: (() -> Void)? = nil
        ) {
            self.id = id
            self.icon = icon
            self.title = title
            self.value = value
            self.iconBackgroundColor = iconBackgroundColor
            self.backgroundColor = backgroundColor
            self.onTap = onTap
        }
    }

    public var items: [Item]
    public var showsBackground: Bool
    public var cornerRadius: CGFloat
    public var spacing: CGFloat

    public init(
        items: [Item],
        showsBackground: Bool = true,
        cornerRadius: CGFloat = 16,
        spacing: CGFloat = 12
    ) {
        self.items = items
        self.showsBackground = showsBackground
        self.cornerRadius = cornerRadius
        self.spacing = spacing
    }
}
