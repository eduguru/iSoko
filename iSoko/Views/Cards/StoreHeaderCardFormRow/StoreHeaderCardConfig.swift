//
//  StoreHeaderCardConfig.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import UIKit

// MARK: - Config

public struct StoreHeaderCardConfig {

    public struct Stat {

        public let value: String
        public let title: String

        public init(
            value: String,
            title: String
        ) {
            self.value = value
            self.title = title
        }
    }

    public var image: UIImage?

    // NEW
    public var name: String?

    public var location: String

    public var verifiedTitle: String?
    public var verifiedImage: UIImage?

    public var stats: [Stat]

    // Card styling
    public var cornerRadius: CGFloat
    public var backgroundColor: UIColor
    public var borderColor: UIColor
    public var borderWidth: CGFloat

    public init(
        image: UIImage?,
        name: String? = nil, // NEW
        location: String,
        verifiedTitle: String? = nil,
        verifiedImage: UIImage? = nil,
        stats: [Stat] = [],
        cornerRadius: CGFloat = 20,
        backgroundColor: UIColor = .systemBackground,
        borderColor: UIColor = .systemGray5,
        borderWidth: CGFloat = 1
    ) {
        self.image = image
        self.name = name // NEW
        self.location = location
        self.verifiedTitle = verifiedTitle
        self.verifiedImage = verifiedImage
        self.stats = stats
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}
