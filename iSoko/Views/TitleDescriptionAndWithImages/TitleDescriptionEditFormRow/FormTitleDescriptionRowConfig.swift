//
//  FormTitleDescriptionRowConfig.swift
//  
//
//  Created by Edwin Weru on 02/10/2025.
//

import UIKit

public struct FormTitleDescriptionRowConfig {
    public let title: String
    public let description: String?
    public let trailingImage: UIImage?
    public let showEditButton: Bool
    public let editButtonTitle: String?
    public let isCardStyleEnabled: Bool
    public let cardCornerRadius: CGFloat
    public let cardBorderWidth: CGFloat
    public let cardBorderColor: UIColor
    public let cardBackgroundColor: UIColor
    public let isEnabled: Bool
    public let onTap: (() -> Void)?
    public let onEditTap: (() -> Void)?

    public init(
        title: String,
        description: String? = nil,
        trailingImage: UIImage? = nil,
        showEditButton: Bool = false,
        editButtonTitle: String? = nil,
        isCardStyleEnabled: Bool = false,
        cardCornerRadius: CGFloat = 8,
        cardBorderWidth: CGFloat = 1,
        cardBorderColor: UIColor = .lightGray,
        cardBackgroundColor: UIColor = .secondarySystemBackground,
        isEnabled: Bool = true,
        onTap: (() -> Void)? = nil,
        onEditTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.trailingImage = trailingImage
        self.showEditButton = showEditButton
        self.editButtonTitle = editButtonTitle
        self.isCardStyleEnabled = isCardStyleEnabled
        self.cardCornerRadius = cardCornerRadius
        self.cardBorderWidth = cardBorderWidth
        self.cardBorderColor = cardBorderColor
        self.cardBackgroundColor = cardBackgroundColor
        self.isEnabled = isEnabled
        self.onTap = onTap
        self.onEditTap = onEditTap
    }
}
