//
//  FeaturedDealsGridFormRow.swift
//  
//
//  Created by Edwin Weru on 13/02/2026.
//

import DesignSystemKit
import UIKit

public final class FeaturedDealsGridFormRow: FormRow {

    public let tag: Int
    public var items: [FeaturedDealItem]

    public var columns: Int?
    public var minimumItemWidth: CGFloat?

    public init(
        tag: Int,
        items: [FeaturedDealItem],
        columns: Int? = 2,
        minimumItemWidth: CGFloat? = nil
    ) {
        self.tag = tag
        self.items = items
        self.columns = columns
        self.minimumItemWidth = minimumItemWidth
    }

    public var reuseIdentifier: String { "FeaturedDealsGridCell" }
    public var cellTag: String { "FeaturedDealsGridFormRow_\(tag)" }

    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { FeaturedDealsGridTableViewCell.self }

    public func configure(_ cell: UITableViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? FeaturedDealsGridTableViewCell else { return cell }

        cell.configure(
            with: items,
            columns: columns,
            minimumItemWidth: minimumItemWidth
        )

        return cell
    }

    public func configure(_ cell: UICollectionViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UICollectionViewCell {
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
