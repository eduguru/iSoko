//
//  InfoListingModel.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import UIKit

public struct InfoListingModel {
    public var title: String?
    public var subtitle: String?
    public var desc: String?
    public var icon: UIImage?
    public var cardBackgroundColor: UIColor?
    public var cardRadius: CGFloat

    public var onTap: (() -> Void)?

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        desc: String? = nil,
        icon: UIImage? = nil,
        cardBackgroundColor: UIColor? = .white,
        cardRadius: CGFloat = 0,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
        self.icon = icon
        self.cardBackgroundColor = cardBackgroundColor
        self.cardRadius = cardRadius
        self.onTap = onTap
    }
}
