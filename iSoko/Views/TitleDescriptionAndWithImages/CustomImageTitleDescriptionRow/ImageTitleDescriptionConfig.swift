import UIKit

//
//  ImageTitleDescriptionConfig.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

public struct ImageTitleDescriptionConfig {
    public enum AccessoryType {
        case none
        case chevron
        case custom(view: UIView)
        case image(image: UIImage)
    }

    public enum ImageStyle {
        case rounded
        case square
    }

    public var image: UIImage?
    public var imageSize: CGSize
    public var imageStyle: ImageStyle

    public var title: String
    public var description: String?

    public var accessoryType: AccessoryType

    public var spacing: CGFloat
    public var contentInsets: UIEdgeInsets

    public var isEnabled: Bool
    public var onTap: (() -> Void)?

    public init(
        image: UIImage? = nil,
        imageSize: CGSize = CGSize(width: 40, height: 40),
        imageStyle: ImageStyle = .rounded,
        title: String,
        description: String? = nil,
        accessoryType: AccessoryType = .chevron,
        spacing: CGFloat = 12,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
        isEnabled: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.image = image
        self.imageSize = imageSize
        self.imageStyle = imageStyle
        self.title = title
        self.description = description
        self.accessoryType = accessoryType
        self.spacing = spacing
        self.contentInsets = contentInsets
        self.isEnabled = isEnabled
        self.onTap = onTap
    }
}
