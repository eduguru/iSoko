//
//  ImageIdentityHeaderRow.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit
import DesignSystemKit

public final class ImageIdentityHeaderRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: ImageIdentityHeaderCell.self)
    public var cellClass: AnyClass? { ImageIdentityHeaderCell.self }

    public let config: ImageIdentityHeaderConfig

    public init(tag: Int, config: ImageIdentityHeaderConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? ImageIdentityHeaderCell else {
            assertionFailure("Expected ImageIdentityHeaderCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
