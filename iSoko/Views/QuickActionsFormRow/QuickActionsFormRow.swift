//
//  QuickActionsFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import DesignSystemKit
import UIKit

public final class QuickActionsFormRow: FormRow {
    public let tag: Int
    public let items: [QuickActionItem]
    public let useCollectionView: Bool

    public init(tag: Int, items: [QuickActionItem], useCollectionView: Bool = false) {
        self.tag = tag
        self.items = items
        self.useCollectionView = useCollectionView
    }

    public var reuseIdentifier: String { "QuickActionsCell" }
    public var cellTag: String { "QuickActionsFormRow_\(tag)" }

    public var rowType: FormRowType {
        return useCollectionView ? .collectionView : .tableView
    }

    public var cellClass: AnyClass? {
        return useCollectionView ? QuickActionsCollectionViewCell.self : QuickActionsTableViewCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? QuickActionsTableViewCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        guard let cell = cell as? QuickActionsCollectionViewCell else { return cell }
        cell.configure(with: items)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
