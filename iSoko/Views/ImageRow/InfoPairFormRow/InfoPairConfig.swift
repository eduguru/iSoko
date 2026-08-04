//
//  InfoPairConfig.swift
//  
//
//  Created by Edwin Weru on 04/08/2026.
//

import UIKit

public struct InfoPairConfig {
    public let title: String?
    public let items: [InfoPairItem]
    public let iconTintColor: UIColor
    public let iconBackgroundColor: UIColor

    public init(
        title: String? = nil,
        items: [InfoPairItem],
        iconTintColor: UIColor = .systemGreen,
        iconBackgroundColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.12)
    ) {
        self.title = title
        self.items = items
        self.iconTintColor = iconTintColor
        self.iconBackgroundColor = iconBackgroundColor
    }
}
