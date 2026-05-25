//
//  EmptyStateConfig.swift
//  DesignSystemKit
//
//  Created by Edwin Weru on 24/05/2026.
//

import UIKit

// MARK: - EmptyStateConfig

public struct EmptyStateConfig {

    public let title: String
    public let message: String?
    public let image: UIImage?
    public let imageHeight: CGFloat

    public init(
        title: String,
        message: String? = nil,
        image: UIImage? = nil,
        imageHeight: CGFloat = 160
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.imageHeight = imageHeight
    }

    // MARK: - Presets

    public static var noResults: EmptyStateConfig {
        EmptyStateConfig(
            title: "No Results Found",
            message: "Try adjusting your search or filters.",
            image: .noData        // replace with your asset name
        )
    }

    public static var noData: EmptyStateConfig {
        EmptyStateConfig(
            title: "Nothing Here Yet",
            message: "Check back later.",
            image: .noData
        )
    }

    public static var error: EmptyStateConfig {
        EmptyStateConfig(
            title: "Something Went Wrong",
            message: "Pull down to try again.",
            image: .noData
        )
    }
}
