//
//  TransactionHeaderRow.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import DesignSystemKit
import UIKit

final class TransactionHeaderRow: FormRow {

    let tag: Int
    let reuseIdentifier = String(describing: TransactionHeaderCell.self)
    var cellClass: AnyClass? { TransactionHeaderCell.self }

    private let config: TransactionHeaderCellConfig

    init(tag: Int, config: TransactionHeaderCellConfig) {
        self.tag = tag
        self.config = config
    }

    func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        (cell as? TransactionHeaderCell)?.configure(with: config)
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
