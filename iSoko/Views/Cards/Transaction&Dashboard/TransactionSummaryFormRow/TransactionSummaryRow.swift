//
//  TransactionSummaryRow.swift
//  
//
//  Created by Edwin Weru on 25/01/2026.
//

import UIKit
import DesignSystemKit

final class TransactionSummaryRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: TransactionSummaryCell.self)
    public var cellClass: AnyClass? { TransactionSummaryCell.self }

    public let config: TransactionSummaryCellConfig

    public init(tag: Int, config: TransactionSummaryCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? TransactionSummaryCell else {
            assertionFailure("Expected TransactionSummaryCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//let config = TransactionSummaryCellConfig(
//    title: "John Doe",
//    amount: "Ksh. 12,987",
//    amountColor: .green,
//    dateText: "Oct 27, 2025",
//    saleTypeText: "Cash Sale",
//    saleTypeTextColor: .white,
//    saleTypeBackgroundColor: .green,
//    itemsCountText: "3 items",
//    cardBackgroundColor: .white,
//    cardBorderColor: .systemGray4,
//    cardBorderWidth: 1,
//    cardCornerRadius: 12
//)
//
//let row = TransactionSummaryRow(tag: 0, config: config)
