//
//  ProfileInfoCellConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import Foundation
import UIKit

public struct ProfileInfoCellConfig {

    public let name: String
    public let nameIcon: UIImage?

    public let infoItems: [InfoItem]

    public let onEditTap: (() -> Void)?

    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat

    public init(
        name: String,
        nameIcon: UIImage? = UIImage(systemName: "person.fill"),
        infoItems: [InfoItem] = [],
        onEditTap: (() -> Void)? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 16
    ) {
        self.name = name
        self.nameIcon = nameIcon
        self.infoItems = infoItems
        self.onEditTap = onEditTap
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
    }
}
