//
//  HorizontalGridFormRow.swift
//  
//
//  Created by Edwin Weru on 23/10/2025.
//

import DesignSystemKit
import UIKit

public final class HorizontalGridFormRow: FormRow {
    public let tag: Int
    public let items: [GridItemModel]

    public init(tag: Int, items: [GridItemModel]) {
        self.tag = tag
        self.items = items
    }

    public var reuseIdentifier: String { "HorizontalGridTableViewCell" }
    public var cellTag: String { "HorizontalGridFormRow_\(tag)" }
    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { HorizontalGridTableViewCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? HorizontalGridTableViewCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        HorizontalGridTableViewCell.estimatedHeight()
    }
}
