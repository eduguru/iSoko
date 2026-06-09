//
//  ProductImageGalleryRow.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import UIKit
import DesignSystemKit

public final class ProductImageGalleryRow: FormRow {
    public let tag: Int
    public var config: ProductImageGalleryConfig

    public let nibName: String? = nil
    public let reuseIdentifier: String = String(describing: ProductImageGalleryCell.self)
    public var cellClass: AnyClass? { ProductImageGalleryCell.self }

    public init(tag: Int, config: ProductImageGalleryConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let galleryCell = cell as? ProductImageGalleryCell else {
            assertionFailure("Expected ProductImageGalleryCell")
            return cell
        }

        galleryCell.configure(with: config)

        return galleryCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {

        let hasMultipleImages = config.images.count > 1

        let pageControlHeight: CGFloat = hasMultipleImages ? 20 : 0
        let thumbnailHeight: CGFloat = hasMultipleImages ? 80 : 0

        return config.imageHeight
            + pageControlHeight
            + thumbnailHeight
            + 24
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
