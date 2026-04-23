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
    public let iconTintColor: UIColor?
    public let onTap: ((Int) -> Void)?

    // Selection appearance
    public let selectionColor: UIColor
    public let selectionImage: UIImage?

    // Behavior
    public let showsSelection: Bool

    public init(
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        iconTintColor: UIColor? = nil,
        selectionColor: UIColor = .systemGreen,
        selectionImage: UIImage? = UIImage(systemName: "checkmark.circle.fill"),
        showsSelection: Bool = true,
        onTap: ((Int) -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconTintColor = iconTintColor
        self.selectionColor = selectionColor
        self.selectionImage = selectionImage
        self.showsSelection = showsSelection
        self.onTap = onTap
    }
}
