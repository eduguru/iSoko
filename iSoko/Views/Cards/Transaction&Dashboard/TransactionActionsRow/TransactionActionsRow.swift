//
//  TransactionActionsRow.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import DesignSystemKit
import UIKit

public final class TransactionActionsRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: TransactionActionsCell.self)
    public var cellClass: AnyClass? { TransactionActionsCell.self }

    public let config: TransactionActionsCellConfig

    public init(tag: Int, config: TransactionActionsCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? TransactionActionsCell else {
            assertionFailure("Expected TransactionActionsCell")
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
