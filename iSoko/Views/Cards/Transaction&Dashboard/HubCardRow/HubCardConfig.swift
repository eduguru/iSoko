//
//  HubCardConfig.swift
//  
//
//  Created by Edwin Weru on 18/03/2026.
//

import UIKit


// MARK: - HubCardConfig

public struct HubCardConfig {

    public struct Action {
        public let id: String
        public let icon: UIImage?
        public let title: String
        public let onTap: (() -> Void)?

        public init(id: String, icon: UIImage?, title: String, onTap: (() -> Void)? = nil) {
            self.id = id
            self.icon = icon
            self.title = title
            self.onTap = onTap
        }
    }

    public var icon: UIImage?
    public var iconBackgroundColor: UIColor?
    public var title: String?
    public var subtitle: String?

    public var actions: [Action]
    public var numberOfColumns: Int
    public var cornerRadius: CGFloat
    public var backgroundColor: UIColor
    public var borderColor: UIColor
    public var borderWidth: CGFloat

    public init(
        icon: UIImage? = nil,
        iconBackgroundColor: UIColor? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        actions: [Action] = [],
        numberOfColumns: Int = 3,
        cornerRadius: CGFloat = 16,
        backgroundColor: UIColor = UIColor.app(.hex("#fffff9")),
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0
    ) {
        self.icon = icon
        self.iconBackgroundColor = iconBackgroundColor
        self.title = title
        self.subtitle = subtitle
        self.actions = actions
        self.numberOfColumns = numberOfColumns
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}
