//
//  ExpenseHeaderRow.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import DesignSystemKit
import UIKit

final class ExpenseHeaderRow: FormRow {

    let tag: Int
    let reuseIdentifier = String(describing: ExpenseHeaderCell.self)
    var cellClass: AnyClass? { ExpenseHeaderCell.self }

    private let config: ExpenseHeaderCellConfig

    init(tag: Int, config: ExpenseHeaderCellConfig) {
        self.tag = tag
        self.config = config
    }

    func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        (cell as? ExpenseHeaderCell)?.configure(with: config)
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//ExpenseHeaderRow(
//    tag: 2,
//    config: ExpenseHeaderCellConfig(
//        title: "Office Supplies",
//        titleIcon: UIImage(systemName: "doc.text"),
//        amountText: NSAttributedString(
//            string: "Ksh. 12,987",
//            attributes: [.foregroundColor: UIColor.systemRed]
//        ),
//        rows: [
//            .init(icon: UIImage(systemName: "truck"),
//                  text: NSAttributedString(string: "Supplier: ABC Company"))
//        ],
//        paymentText: "Cash",
//        paymentTextColor: .systemGreen,
//        paymentBackgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
//        dateText: NSAttributedString(string: "Oct 27, 2025"),
//        cardStyle: .default
//    )
//)
