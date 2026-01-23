//
//  DualCardItemConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public struct DualCardItemConfig {

    public let title: String
    public let titleIcon: UIImage?

    public let subtitle: String?

    public let status: CardStatusStyle?

    public let backgroundColor: UIColor
    public let borderColor: UIColor
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat

    public let onTap: (() -> Void)?

    public init(
        title: String,
        titleIcon: UIImage? = nil,
        subtitle: String? = nil,
        status: CardStatusStyle? = nil,
        backgroundColor: UIColor = .systemBackground,
        borderColor: UIColor = .systemGray4,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 12,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.titleIcon = titleIcon
        self.subtitle = subtitle
        self.status = status
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.onTap = onTap
    }
}
