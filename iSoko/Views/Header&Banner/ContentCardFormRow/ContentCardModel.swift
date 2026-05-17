//
//  ContentCardModel.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

public struct ContentCardModel {

    public var title: String

    public var text: String?

    public var image: UIImage?

    public var imageURL: URL?

    public var fallbackImage: UIImage

    public var imagePosition: CardImagePosition

    public var imageHeight: CGFloat?

    public var maxImageHeight: CGFloat?

    public var cardSettings: CardSettings

    public init(
        title: String,
        text: String? = nil,
        image: UIImage? = nil,
        imageURL: URL? = nil,
        fallbackImage: UIImage = UIImage(),
        imagePosition: CardImagePosition = .center,
        imageHeight: CGFloat? = nil,
        maxImageHeight: CGFloat? = 180,
        cardSettings: CardSettings = .default
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.imageURL = imageURL
        self.fallbackImage = fallbackImage
        self.imagePosition = imagePosition
        self.imageHeight = imageHeight
        self.maxImageHeight = maxImageHeight
        self.cardSettings = cardSettings
    }
}
