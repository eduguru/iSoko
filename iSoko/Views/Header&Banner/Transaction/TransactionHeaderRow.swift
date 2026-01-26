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

//TransactionHeaderRow(
//    tag: 1,
//    config: TransactionHeaderCellConfig(
//        title: "Sale #987654",
//        titleIcon: UIImage(systemName: "cart"),
//        leftColumn: [
//            .init(icon: UIImage(systemName: "calendar"),
//                  text: NSAttributedString(string: "26/04/2025")),
//            .init(icon: UIImage(systemName: "creditcard"),
//                  text: NSAttributedString(string: "Mobile Money"))
//        ],
//        rightColumn: [
//            .init(icon: UIImage(systemName: "person"),
//                  text: NSAttributedString(string: "John Doe")),
//            .init(icon: UIImage(systemName: "calendar.badge.exclamationmark"),
//                  text: NSAttributedString(
//                      string: "30/04/2025",
//                      attributes: [.foregroundColor: UIColor.systemRed]
//                  ))
//        ],
//        statusText: "Credit Sale",
//        statusTextColor: .systemBlue,
//        statusBackgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
//        cardStyle: .default
//    )
//)
