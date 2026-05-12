//
//  ActionButtonConfig.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

// MARK: - Action Button Config

public struct ActionButtonConfig {

    public enum Style {
        case filled
        case outlined
        case subtle
    }

    public let title: String
    public let style: Style

    public let backgroundColor: UIColor
    public let textColor: UIColor
    public let borderColor: UIColor

    public let onTap: (() -> Void)?

    public init(
        title: String,
        style: Style,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .label,
        borderColor: UIColor = .clear,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.onTap = onTap
    }
}

