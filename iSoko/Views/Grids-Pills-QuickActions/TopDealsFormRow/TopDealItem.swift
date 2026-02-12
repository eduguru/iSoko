//
//  TopDealItem.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public struct TopDealItem {

    public let id: String
    public let imageUrl: String?
    public let image: UIImage?
    public let badgeText: String?
    public let title: String
    public let subtitle: String?
    public let priceText: String

    public var isFavorite: Bool
    public let onTap: (() -> Void)?
    public let onFavoriteToggle: ((Bool) -> Void)?

    public init(
        id: String,
        imageUrl: String? = nil,
        image: UIImage? = nil,
        badgeText: String? = nil,
        title: String,
        subtitle: String? = nil,
        priceText: String,
        isFavorite: Bool = false,
        onTap: (() -> Void)? = nil,
        onFavoriteToggle: ((Bool) -> Void)? = nil
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.image = image
        self.badgeText = badgeText
        self.title = title
        self.subtitle = subtitle
        self.priceText = priceText
        self.isFavorite = isFavorite
        self.onTap = onTap
        self.onFavoriteToggle = onFavoriteToggle
    }
}
