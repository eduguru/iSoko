//
//  RichDescriptionFormRow.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import DesignSystemKit
import UIKit

public final class RichDescriptionFormRow: FormRow {

    public let tag: Int
    public let model: RichDescriptionModel

    public let reuseIdentifier = String(describing: RichDescriptionFormCell.self)
    public var cellClass: AnyClass? { RichDescriptionFormCell.self }
    public let rowType: FormRowType = .tableView

    public init(tag: Int, model: RichDescriptionModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        guard let cell = cell as? RichDescriptionFormCell else {
            assertionFailure("Expected RichDescriptionFormCell")
            return cell
        }

        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
