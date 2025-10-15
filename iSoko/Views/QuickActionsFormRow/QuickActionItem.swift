//
//  QuickActionItem.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

// MARK: - Model

public struct QuickActionItem {
    public enum ImageShape {
        case circle
        case rounded(CGFloat)
        case square
    }

    public let id: String
    public let image: UIImage?
    public let imageUrl: String?
    public let imageSize: CGSize
    public let imageShape: ImageShape
    public let title: String
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let onTap: (() -> Void)?

    public init(
        id: String,
        image: UIImage? = nil,
        imageUrl: String? = nil,
        imageSize: CGSize = CGSize(width: 60, height: 60),
        imageShape: ImageShape = .circle,
        title: String,
        titleFont: UIFont = .systemFont(ofSize: 14),
        titleColor: UIColor = .label,
        onTap: (() -> Void)? = nil
    ) {
        self.id = id
        self.image = image
        self.imageUrl = imageUrl
        self.imageSize = imageSize
        self.imageShape = imageShape
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.onTap = onTap
    }
}
