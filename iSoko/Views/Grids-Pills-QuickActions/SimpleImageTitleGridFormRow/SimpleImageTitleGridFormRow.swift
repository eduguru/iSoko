//
//  SimpleImageTitleGridFormRow.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import DesignSystemKit
import UIKit

public final class SimpleImageTitleGridFormRow: FormRow {
    public let tag: Int
    public let items: [SimpleImageTitleGridModel]
    public let numberOfColumns: Int
    public let useCollectionView: Bool

    public init(
        tag: Int,
        items: [SimpleImageTitleGridModel],
        numberOfColumns: Int = 2,
        useCollectionView: Bool = false
    ) {
        self.tag = tag
        self.items = items
        self.numberOfColumns = numberOfColumns
        self.useCollectionView = useCollectionView
    }

    public var reuseIdentifier: String {
        useCollectionView ? "SimpleImageTitleGridCollectionViewRowCell" : "SimpleImageTitleGridTableViewCell"
    }

    public var cellTag: String { "GridFormRow_\(tag)" }

    public var rowType: FormRowType {
        useCollectionView ? .collectionView : .tableView
    }

    public var cellClass: AnyClass? {
        useCollectionView ? SimpleImageTitleGridCollectionViewRowCell.self : SimpleImageTitleGridTableViewCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        print("Configuring SimpleImageTitleGridFormRow with items: \(items)")
        guard let cell = cell as? SimpleImageTitleGridTableViewCell else {
            return cell
        }
        
        cell.configure(with: items, columns: numberOfColumns)
        return cell
    }

    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        print("SimpleImageTitleGridCollectionViewRowCell Configuring cell at indexPath: \(indexPath)")
        guard let cell = cell as? SimpleImageTitleGridCollectionViewRowCell else {
            return cell
        }
        
        cell.configure(with: items, columns: numberOfColumns)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        let rows = ceil(Double(items.count) / Double(numberOfColumns))
        let heightPerRow: CGFloat = 80
        let spacing: CGFloat = 12
        let insets: CGFloat = 16
        return CGFloat(rows) * heightPerRow + CGFloat(rows - 1) * spacing + insets
    }
}
