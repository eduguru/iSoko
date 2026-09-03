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
        switch layoutMode {
        case .scrollable:
            return 56
        case .segmentedStretch:
            // Each row of pills is 40px tall + 16px insets; calculate rows needed
            let screenWidth = UIScreen.main.bounds.width
            let interItemSpacing: CGFloat = 12
            let sectionInsets: CGFloat = 32 // 16 left + 16 right
            let pillHeight: CGFloat = 40
            let verticalInsets: CGFloat = 16 // 8 top + 8 bottom

            let availableWidth = screenWidth - sectionInsets
            let itemWidth = (availableWidth - (CGFloat(items.count - 1) * interItemSpacing)) / CGFloat(items.count)

            // If any item's text doesn't fit its calculated width, it needs to scroll
            let allFit = items.allSatisfy { item in
                let textWidth = (item.title as NSString)
                    .size(withAttributes: [.font: item.font]).width + item.horizontalPadding * 2
                return textWidth <= itemWidth
            }

            return allFit ? pillHeight + verticalInsets : 56
        }
    }
}
