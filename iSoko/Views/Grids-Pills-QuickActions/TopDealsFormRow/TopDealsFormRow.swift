//
//  TopDealsFormRow.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import DesignSystemKit
import UIKit

public final class TopDealsFormRow: FormRow {

    public let tag: Int
    public var items: [TopDealItem]

    public init(tag: Int, items: [TopDealItem]) {
        self.tag = tag
        self.items = items
    }

    public var reuseIdentifier: String { "TopDealsCell" }
    public var cellTag: String { "TopDealsFormRow_\(tag)" }

    // IMPORTANT: Must be tableView
    public var rowType: FormRowType { .tableView }

    // IMPORTANT: Must be UITableViewCell subclass
    public var cellClass: AnyClass? { TopDealsTableViewCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TopDealsTableViewCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 320
    }
}
