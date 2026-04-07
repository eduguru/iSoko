//
//  ImagePreviewFormRow.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import DesignSystemKit
import UIKit

public final class ImagePreviewFormRow: FormRow {

    public let tag: Int
    public var items: [ImagePreviewItem]
    public let onRemove: ((Int) -> Void)?

    public init(
        tag: Int,
        items: [ImagePreviewItem],
        onRemove: ((Int) -> Void)? = nil
    ) {
        self.tag = tag
        self.items = items
        self.onRemove = onRemove
    }

    public var reuseIdentifier: String { "ImagePreviewCell" }
    public var cellTag: String { "ImagePreviewFormRow_\(tag)" }

    public var rowType: FormRowType { .tableView }
    public var cellClass: AnyClass? { ImagePreviewTableViewCell.self }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? ImagePreviewTableViewCell else { return cell }

        cell.configure(
            items: items,
            onRemove: onRemove
        )

        return cell
    }

    public func configure(
        _ cell: UICollectionViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UICollectionViewCell {
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return items.isEmpty ? 0 : 110
    }
}
