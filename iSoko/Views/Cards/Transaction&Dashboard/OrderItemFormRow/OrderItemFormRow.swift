//
//  OrderItemFormRow.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import DesignSystemKit
import UIKit

// MARK: - Form Row

public final class OrderItemFormRow: FormRow {

    public let tag: Int

    public let reuseIdentifier =
        String(describing: OrderItemCell.self)

    public var cellClass: AnyClass? {
        OrderItemCell.self
    }

    public let config: OrderItemCellConfig

    public init(
        tag: Int,
        config: OrderItemCellConfig
    ) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? OrderItemCell else {
            assertionFailure("Expected OrderItemCell")
            return cell
        }

        cell.configure(with: config)

        return cell
    }

    @MainActor
    public func preferredHeight(
        for indexPath: IndexPath
    ) -> CGFloat {

        UITableView.automaticDimension
    }
}
