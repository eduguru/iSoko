//
//  KeyValueFormRow.swift
//  
//
//  Created by Edwin Weru on 05/03/2026.
//

import DesignSystemKit
import UIKit

public final class KeyValueFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: KeyValueFormCell.self)
    public var cellClass: AnyClass? { KeyValueFormCell.self }

    public let rowType: FormRowType = .tableView

    public var model: KeyValueRowModel

    public init(tag: Int, model: KeyValueRowModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? KeyValueFormCell else {
            assertionFailure("Expected KeyValueFormCell")
            return cell
        }

        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}

public extension KeyValueFormRow {
    convenience init(
        tag: Int,
        leftText: String,
        rightText: String
    ) {
        let model = KeyValueRowModel(
            leftText: leftText,
            rightText: rightText
        )
        self.init(tag: tag, model: model)
    }
}
