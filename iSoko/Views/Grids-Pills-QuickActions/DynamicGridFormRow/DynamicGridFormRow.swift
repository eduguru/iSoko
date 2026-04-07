//
//  DynamicGridFormRow.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit
import DesignSystemKit

public final class DynamicGridFormRow<Item, Cell: UICollectionViewCell>: FormRow {

    public let tag: Int
    public var items: [Item]

    public var columns: Int?
    public var minimumItemWidth: CGFloat?

    private let cellType: Cell.Type
    public let reuseIdentifier: String
    private let configureCell: (Cell, Item, IndexPath) -> Void
    private let onSelect: ((Item, IndexPath) -> Void)?
    private let itemHeight: ((Item, CGFloat) -> CGFloat)?

    public init(
        tag: Int,
        items: [Item],
        cellType: Cell.Type,
        reuseIdentifier: String = String(describing: Cell.self),
        columns: Int? = 2,
        minimumItemWidth: CGFloat? = nil,
        itemHeight: ((Item, CGFloat) -> CGFloat)? = nil,
        configureCell: @escaping (Cell, Item, IndexPath) -> Void,
        onSelect: ((Item, IndexPath) -> Void)? = nil
    ) {
        self.tag = tag
        self.items = items
        self.cellType = cellType
        self.reuseIdentifier = reuseIdentifier
        self.columns = columns
        self.minimumItemWidth = minimumItemWidth
        self.configureCell = configureCell
        self.onSelect = onSelect
        self.itemHeight = itemHeight
    }

    public var cellTag: String { "DynamicGridFormRow_\(tag)" }
    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { DynamicGridTableViewCell<Item, Cell>.self }

    public func configure(_ cell: UITableViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? DynamicGridTableViewCell<Item, Cell> else { return cell }

        cell.configure(
            items: items,
            cellType: cellType,
            reuseIdentifier: reuseIdentifier,
            columns: columns,
            minimumItemWidth: minimumItemWidth,
            itemHeight: itemHeight,
            configureCell: configureCell,
            onSelect: onSelect
        )

        return cell
    }

    public func configure(_ cell: UICollectionViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UICollectionViewCell {
        
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
