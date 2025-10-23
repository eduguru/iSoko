//
//  GridItemModel.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public struct GridItemModel {
    public let id: String
    public let image: UIImage?
    public let imageUrl: String?
    public let title: String
    public let subtitle: String?
    public let price: String?
    
    public var isFavorite: Bool
    public var onTap: (() -> Void)?
    public var onToggleFavorite: ((_ newValue: Bool) -> Void)?
    
    public init(
        id: String,
        image: UIImage? = nil,
        imageUrl: String? = nil,
        title: String,
        subtitle: String? = nil,
        price: String? = nil,
        isFavorite: Bool = false,
        onTap: (() -> Void)? = nil,
        onToggleFavorite: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.id = id
        self.image = image
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.isFavorite = isFavorite
        self.onTap = onTap
        self.onToggleFavorite = onToggleFavorite
    }
}
