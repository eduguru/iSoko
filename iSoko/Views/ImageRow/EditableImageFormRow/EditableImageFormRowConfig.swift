//
//  EditableImageFormRowConfig.swift
//  
//
//  Created by Edwin Weru on 11/11/2025.
//

import UIKit

public struct EditableImageFormRowConfig {
    public enum Alignment {
        case left, right, center
    }

    public var image: UIImage?
    public var editButtonImage: UIImage?
    public var imageHeight: CGFloat
    public var fillWidth: Bool
    public var alignment: Alignment
    public var editable: Bool

    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var aspectRatio: CGFloat?

    public init(
        image: UIImage? = nil,
        editButtonImage: UIImage? = nil,
        height: CGFloat = 100,
        fillWidth: Bool = false,
        alignment: Alignment = .center,
        editable: Bool = false,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        aspectRatio: CGFloat? = nil
    ) {
        self.image = image
        self.editButtonImage = editButtonImage
        self.imageHeight = height
        self.fillWidth = fillWidth
        self.alignment = alignment
        self.editable = editable
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
    }
}
