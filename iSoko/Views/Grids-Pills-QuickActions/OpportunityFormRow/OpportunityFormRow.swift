//
//  OpportunityFormRow.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import DesignSystemKit
import UIKit

public final class OpportunityFormRow: FormRow {
    public let tag: Int
    public var items: [OpportunityItem]

    public init(tag: Int, items: [OpportunityItem]) {
        self.tag = tag
        self.items = items
    }

    public var reuseIdentifier: String { "OpportunityRow" }
    public var cellTag: String { "OpportunityFormRow_\(tag)" }
    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { OpportunityTableCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? OpportunityTableCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 340
    }
}
