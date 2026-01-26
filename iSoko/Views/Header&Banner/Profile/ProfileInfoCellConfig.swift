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

    public let phone: String?
    public let email: String?
    public let location: String?

    public let onEditTap: (() -> Void)?

    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat

    public init(
        name: String,
        phone: String? = nil,
        email: String? = nil,
        location: String? = nil,
        onEditTap: (() -> Void)? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray4,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 16
    ) {
        self.name = name
        self.phone = phone
        self.email = email
        self.location = location
        self.onEditTap = onEditTap
        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius
    }
}
