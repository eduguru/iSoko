//
//  GridFormRow.swift
//  
//
//  Created by Edwin Weru on 12/10/2025.
//

import DesignSystemKit
import UIKit

public final class GridFormRow: FormRow {
    public let tag: Int
    public let items: [GridItemModel]
    public let numberOfColumns: Int
    public let useCollectionView: Bool

    public init(
        tag: Int,
        items: [GridItemModel],
        numberOfColumns: Int = 2,
        useCollectionView: Bool = false
    ) {
        self.tag = tag
        self.items = items
        self.numberOfColumns = numberOfColumns
        self.useCollectionView = useCollectionView
    }

    public var reuseIdentifier: String {
        useCollectionView ? "GridCollectionViewRowCell" : "GridTableViewCell"
    }

    public var cellTag: String { "GridFormRow_\(tag)" }

    public var rowType: FormRowType {
        useCollectionView ? .collectionView : .tableView
    }

    public var cellClass: AnyClass? {
        useCollectionView ? GridCollectionViewRowCell.self : GridTableViewCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? GridTableViewCell else { return cell }
        cell.configure(with: items, columns: numberOfColumns)
        return cell
    }

    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        guard let cell = cell as? GridCollectionViewRowCell else { return cell }
        cell.configure(with: items, columns: numberOfColumns)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        let rows = ceil(Double(items.count) / Double(numberOfColumns))
        let heightPerRow: CGFloat = 180
        let spacing: CGFloat = 12
        let insets: CGFloat = 16
        return CGFloat(rows) * heightPerRow + CGFloat(rows - 1) * spacing + insets
    }
}
