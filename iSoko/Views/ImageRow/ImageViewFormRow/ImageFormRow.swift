//
//  ImageFormRow.swift
//  Base App
//
//  Created by Edwin Weru on 04/08/2025.
//

import DesignSystemKit
import UIKit

// MARK: - ImageFormRow

public final class ImageFormRow: FormRow {
    public let tag: Int
    public var config: ImageFormRowConfig

    public let nibName: String? = nil
    public let reuseIdentifier: String = String(describing: ImageFormCell.self)
    public var cellClass: AnyClass? { ImageFormCell.self }

    public var modelDidUpdate: ((UIImage?, CGFloat) -> Void)?

    public init(tag: Int, config: ImageFormRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let imageCell = cell as? ImageFormCell else {
            assertionFailure("Expected ImageFormCell")
            return cell
        }

        imageCell.configure(with: config)

        imageCell.onModelUpdate = { [weak self] updatedImage, updatedHeight in
            self?.config.image = updatedImage
            self?.config.imageHeight = updatedHeight
            self?.modelDidUpdate?(updatedImage, updatedHeight)
        }

        return imageCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        config.imageHeight + 32 // 16 top + 16 bottom
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
