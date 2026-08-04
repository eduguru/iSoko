//
//  InfoPairItem.swift
//  
//
//  Created by Edwin Weru on 04/08/2026.
//

import UIKit

// MARK: - Model

public struct InfoPairItem {
    public let icon: UIImage?
    public let label: String
    public let value: String?
    public let valueColor: UIColor
    public let isLink: Bool
    public let onTap: (() -> Void)?

    public init(
        icon: UIImage?,
        label: String,
        value: String? = nil,
        valueColor: UIColor = .label,
        isLink: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.label = label
        self.value = value
        self.valueColor = valueColor
        self.isLink = isLink
        self.onTap = onTap
    }
}
