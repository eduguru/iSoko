//
//  ProductImageGalleryConfig.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import UIKit

public struct ProductImage {
    public let url: URL
    public let isFeatured: Bool

    /// Initializes with URL
    public init(url: URL, isFeatured: Bool) {
        self.url = url
        self.isFeatured = isFeatured
    }

    /// Initializes with URL string (optional)
    public init?(urlString: String, isFeatured: Bool) {
        guard let validURL = URL(string: urlString) else {
            return nil
        }
        self.url = validURL
        self.isFeatured = isFeatured
    }
}

public struct ProductImageGalleryConfig {
    public var images: [ProductImage]
    public var imageHeight: CGFloat

    public var placeholderImage: UIImage?
    public var fallbackImage: UIImage?

    public init(images: [ProductImage], imageHeight: CGFloat = 180, placeholderImage: UIImage? = nil, fallbackImage: UIImage? = nil) {
        self.images = images
        self.imageHeight = imageHeight
        self.placeholderImage = placeholderImage
        self.fallbackImage = fallbackImage
    }
}
