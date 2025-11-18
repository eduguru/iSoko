//
//  ImageTitleGridFormRow.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import DesignSystemKit
import UIKit

public final class ImageTitleGridFormRow: FormRow {
    public let tag: Int
    public let items: [ImageTitleGridItemModel]
    public let numberOfColumns: Int

    public init(
        tag: Int,
        items: [ImageTitleGridItemModel],
        numberOfColumns: Int = 2,
    ) {
        self.tag = tag
        self.items = items
        self.numberOfColumns = numberOfColumns
    }

    public var reuseIdentifier: String = "ImageTitleGridTableViewCell"

    public var cellTag: String { "ImageTitleGridFormRow\(tag)" }

    public var rowType: FormRowType {
        .tableView
    }

    public var cellClass: AnyClass? {
        ImageTitleGridTableViewCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? ImageTitleGridTableViewCell else { return cell }
        cell.configure(with: items, columns: numberOfColumns)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        let rows = ceil(Double(items.count) / Double(numberOfColumns))
        let heightPerRow: CGFloat = 200
        let spacing: CGFloat = 12
        let insets: CGFloat = 16
        return CGFloat(rows) * heightPerRow + CGFloat(rows - 1) * spacing + insets
    }
}
