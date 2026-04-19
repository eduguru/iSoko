//
//  PillsFormRowV2.swift
//  
//
//  Created by Edwin Weru on 17/04/2026.
//

import DesignSystemKit
import UIKit

public final class PillsFormRowV2: FormRow {
    public let tag: Int
    public var items: [PillItem]

    public let layoutMode: PillsLayoutMode
    public let selectionMode: PillsSelectionMode
    public let onSelectionChanged: PillsSelectionHandler?

    public init(
        tag: Int,
        items: [PillItem],
        layoutMode: PillsLayoutMode = .scrollable,
        selectionMode: PillsSelectionMode = .multiple,
        onSelectionChanged: PillsSelectionHandler? = nil
    ) {
        self.tag = tag
        self.items = items
        self.layoutMode = layoutMode
        self.selectionMode = selectionMode
        self.onSelectionChanged = onSelectionChanged
    }

    public var rowType: FormRowType { .tableView }
    public var cellTag: String { "PillsFormRowV2\(tag)" }

    public let reuseIdentifier = String(describing: PillsTableViewCell.self)
    public var cellClass: AnyClass? { PillsTableViewCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? PillsTableViewCell else { return cell }

        cell.configure(
            with: items,
            layoutMode: layoutMode,
            selectionMode: selectionMode,
            onSelectionChanged: { [weak self] updatedItems in
                self?.items = updatedItems
                self?.onSelectionChanged?(updatedItems)
            }
        )

        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

//
//private func makePillsOptionsFormRow() -> FormRow {
//    PillsFormRowV2(
//        tag: 98,
//        items: [
//            PillItem(id: "1", title: "Cash"),
//            PillItem(id: "2", title: "Credit")
//        ],
//        layoutMode: .segmentedStretch,
//        selectionMode: .single
//    ) { items in
//        print(items.first(where: { $0.isSelected }))
//    }
//    
//        PillsFormRowV2(
//            tag: 99,
//            items: options,
//            layoutMode: .scrollable,
//            selectionMode: .multiple
//        )
//}
