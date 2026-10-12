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
            title: "common.empty.no_results".localized,
            message: "common.empty.adjust_search".localized,
            image: .noData        // replace with your asset name
        )
    }

    public static var noData: EmptyStateConfig {
        EmptyStateConfig(
            title: "common.empty.nothing_here".localized,
            message: "common.empty.check_back_later".localized,
            image: .noData
        )
    }

    public static var error: EmptyStateConfig {
        EmptyStateConfig(
            title: "common.empty.something_went_wrong".localized,
            message: "common.empty.pull_to_retry".localized,
            image: .noData
        )
    }
}
