//
//  TransactionFormRow.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import UIKit
import DesignSystemKit

public final class TransactionRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: TransactionCell.self)
    public var cellClass: AnyClass? { TransactionCell.self }

    public let config: TransactionCellConfig

    public init(tag: Int, config: TransactionCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TransactionCell else {
            assertionFailure("Expected TransactionCell")
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
