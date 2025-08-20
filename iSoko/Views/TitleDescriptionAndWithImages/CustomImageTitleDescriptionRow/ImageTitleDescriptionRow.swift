//
//  ImageTitleDescriptionRow.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import DesignSystemKit
import UIKit

public final class ImageTitleDescriptionRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: ImageTitleDescriptionCell.self)
    public var cellClass: AnyClass? { ImageTitleDescriptionCell.self }

    public let config: ImageTitleDescriptionConfig

    public init(tag: Int, config: ImageTitleDescriptionConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? ImageTitleDescriptionCell else {
            assertionFailure("Expected ImageTitleDescriptionCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
