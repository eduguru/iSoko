//
//  FiltersFormRow.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import DesignSystemKit
import UIKit


public final class FiltersFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: FiltersCell.self)
    public var cellClass: AnyClass? { FiltersCell.self }

    private let config: FiltersCellConfig

    public init(tag: Int, config: FiltersCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? FiltersCell else {
            assertionFailure("Expected FiltersCell")
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
