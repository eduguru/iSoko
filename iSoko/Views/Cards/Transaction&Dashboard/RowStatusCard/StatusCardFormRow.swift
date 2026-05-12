//
//  StatusCardFormRow.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import DesignSystemKit
import UIKit

public final class StatusCardFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: StatusCardFormCell.self)
    public var cellClass: AnyClass? { StatusCardFormCell.self }

    public let model: StatusCardModel

    public init(tag: Int, model: StatusCardModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? StatusCardFormCell else { return cell }
        cell.configure(with: model)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
