//
//  KeyValueGroupFormRow.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import UIKit
import DesignSystemKit

public final class KeyValueGroupFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: KeyValueGroupFormCell.self)
    public var cellClass: AnyClass? { KeyValueGroupFormCell.self }

    public let model: KeyValueGroupModel

    public init(tag: Int, model: KeyValueGroupModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? KeyValueGroupFormCell else { return cell }
        cell.configure(with: model)

        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
