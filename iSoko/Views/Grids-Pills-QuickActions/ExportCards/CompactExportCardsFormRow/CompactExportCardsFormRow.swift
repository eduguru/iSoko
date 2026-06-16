//
//  CompactExportCardsFormRow.swift
//  
//
//  Created by Edwin Weru on 16/06/2026.
//

import DesignSystemKit
import UIKit

public final class CompactExportCardsFormRow: FormRow {


    public let tag: Int
    public var items: [ExportCardItem]


    public init(
        tag: Int,
        items: [ExportCardItem]
    ) {
        self.tag = tag
        self.items = items
    }


    public var reuseIdentifier: String {
        "CompactExportCardsRow"
    }


    public var cellTag: String {
        "CompactExportCardsFormRow_\(tag)"
    }


    public var rowType: FormRowType {
        .tableView
    }


    public var cellClass: AnyClass? {
        CompactExportCardsTableCell.self
    }


    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {


        guard let cell = cell as? CompactExportCardsTableCell
        else {
            return cell
        }


        cell.configure(with: items)

        return cell
    }


    public func preferredHeight(
        for indexPath: IndexPath
    ) -> CGFloat {

        150
    }
}
