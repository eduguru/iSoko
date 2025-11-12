//
//  ImageTitleDescriptionBottomRow.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit

public final class ImageTitleDescriptionBottomRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: ImageTitleDescriptionBottomCell.self)
    public var cellClass: AnyClass? { ImageTitleDescriptionBottomCell.self }

    public var config: ImageTitleDescriptionBottomConfig

    public init(tag: Int, config: ImageTitleDescriptionBottomConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController? = nil
    ) -> UITableViewCell {
        guard let cell = cell as? ImageTitleDescriptionBottomCell else {
            assertionFailure("Expected ImageTitleDescriptionBottomCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // Validation hooks for form system
    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
