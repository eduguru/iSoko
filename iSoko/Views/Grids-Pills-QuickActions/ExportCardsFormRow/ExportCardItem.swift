//
//  ExportCardItem.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public struct ExportCardItem {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let icon: UIImage?
    public let imageUrls: [String]
    public let images: [UIImage?]  
    public let onTap: (() -> Void)?

    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        imageUrls: [String] = [],   //NEW
        images: [UIImage?] = [],
        onTap: (() -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.imageUrls = imageUrls
        self.images = images
        self.onTap = onTap
    }
}
