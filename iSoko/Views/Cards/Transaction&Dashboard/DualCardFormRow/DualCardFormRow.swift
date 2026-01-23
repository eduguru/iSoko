//
//  DualCardFormRow.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import DesignSystemKit
import UIKit

public final class DualCardFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: DualCardCell.self)
    public var cellClass: AnyClass? { DualCardCell.self }

    public let config: DualCardCellConfig

    public init(tag: Int, config: DualCardCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? DualCardCell else {
            assertionFailure("Expected DualCardCell")
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
