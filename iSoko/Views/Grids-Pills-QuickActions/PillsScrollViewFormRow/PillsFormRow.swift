//
//  PillsFormRow.swift
//  
//
//  Created by Edwin Weru on 02/12/2025.
//

import DesignSystemKit
import UIKit

public final class PillsFormRow: FormRow {
    public let tag: Int
    public let items: [PillItem]

    public init(tag: Int, items: [PillItem]) {
        self.tag = tag
        self.items = items
    }
    
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { "PillsFormRow\(tag)" }
    
    
    public let reuseIdentifier = String(describing: PillsTableViewCell.self)
    public var cellClass: AnyClass? { PillsTableViewCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? PillsTableViewCell else { return cell }
        cell.configure(with: items)
        return cell
    }
    
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        // Ensure you have access to the `items` array, which is already defined as a property in the PillsTableViewCell
        return PillsTableViewCell.estimatedHeight(for: items)
    }

}
