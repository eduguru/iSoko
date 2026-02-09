//
//  UploadFormRowConfig.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

public enum UploadFieldStyle {
    case dashed
    case roundedButton
}

public struct UploadFormRowConfig {
    public var style: UploadFieldStyle
    public var title: String
    public var subtitle: String?
    public var icon: UIImage?
    public var borderColor: UIColor
    public var backgroundColor: UIColor
    public var cornerRadius: CGFloat
    public var height: CGFloat

    public init(
        style: UploadFieldStyle = .dashed,
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        borderColor: UIColor = .lightGray,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 10,
        height: CGFloat = 120
    ) {
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.height = height
    }
}
