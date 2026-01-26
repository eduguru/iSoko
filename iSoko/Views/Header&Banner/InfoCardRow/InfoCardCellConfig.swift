//
//  InfoCardCellConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public struct InfoCardCellConfig {

    public let title: String
    public let titleIcon: UIImage?

    public let rows: [Row]

    public let statusText: String?
    public let statusTextColor: UIColor
    public let statusBackgroundColor: UIColor

    public let onEditTap: (() -> Void)?

    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat

    public struct Row {
        public let icon: UIImage?
        public let text: NSAttributedString?

        public init(icon: UIImage?, text: NSAttributedString?) {
            self.icon = icon
            self.text = text
        }
    }

    public init(
        title: String,
        titleIcon: UIImage? = nil,
        rows: [Row],
        statusText: String? = nil,
        statusTextColor: UIColor = .systemGreen,
        statusBackgroundColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.15),
        onEditTap: (() -> Void)? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 16
    ) {
        self.title = title
        self.titleIcon = titleIcon
        self.rows = rows
        self.statusText = statusText
        self.statusTextColor = statusTextColor
        self.statusBackgroundColor = statusBackgroundColor
        self.onEditTap = onEditTap
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
    }
}
