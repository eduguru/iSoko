//
//  ExportCardsFormRow.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import DesignSystemKit
import UIKit

public final class ExportCardsFormRow: FormRow {

    public let tag: Int
    public var items: [ExportCardItem]

    public init(tag: Int, items: [ExportCardItem]) {
        self.tag = tag
        self.items = items
    }

    public var reuseIdentifier: String { "ExportCardsRow" }
    public var cellTag: String { "ExportCardsFormRow_\(tag)" }
    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { ExportCardsTableCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? ExportCardsTableCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 320
    }
}
