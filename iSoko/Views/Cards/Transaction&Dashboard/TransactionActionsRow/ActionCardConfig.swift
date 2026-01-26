//
//  ActionCardConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public struct ActionCardConfig {
    public let title: String
    public let icon: UIImage?
    public let backgroundColor: UIColor
    public let textColor: UIColor
    public let onTap: (() -> Void)?

    public init(
        title: String,
        icon: UIImage?,
        backgroundColor: UIColor = .systemGray6,
        textColor: UIColor = .label,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.onTap = onTap
    }
}

public struct InlineActionConfig {
    public let title: String
    public let icon: UIImage?
    public let onTap: (() -> Void)?

    public init(
        title: String,
        icon: UIImage?,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.onTap = onTap
    }
}
