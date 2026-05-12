//
//  ImageFormRowConfig.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import UIKit

public struct ImageFormRowConfig {
    public var image: UIImage?
    public var imageURL: URL?          
    public var imageHeight: CGFloat
    public var fillWidth: Bool

    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var aspectRatio: CGFloat?

    public init(
        image: UIImage? = nil,
        imageURL: URL? = nil,
        height: CGFloat = 100,
        fillWidth: Bool = false,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        aspectRatio: CGFloat? = nil
    ) {
        self.image = image
        self.imageURL = imageURL
        self.imageHeight = height
        self.fillWidth = fillWidth
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
    }
}
