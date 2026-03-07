//
//  SelectableCardItemConfig.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

// MARK: - SelectableCardItemConfig
public struct SelectableCardItemConfig {
    public let title: String
    public let subtitle: String?
    public let icon: UIImage?
    public let onTap: ((Int) -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        onTap: ((Int) -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.onTap = onTap
    }
}
