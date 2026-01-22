//
//  TitleDropDownFilterFormRow.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit

public final class TitleDropDownFilterFormRow: FormRow {

    public let tag: Int

    public var reuseIdentifier: String = String(describing: TitleDropDownFilterViewCell.self)
    public var cellTag: String { "\(reuseIdentifier)\(tag)" }
    public var rowType: FormRowType { .tableView }

    public var nibName: String? { reuseIdentifier }
    public var cellClass: AnyClass? { TitleDropDownFilterViewCell.self }

    // Configuration model
    public let model: TitleDropDownFilterModel

    public init(tag: Int, model: TitleDropDownFilterModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? TitleDropDownFilterViewCell else {
            return cell
        }

        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        50// UITableView.automaticDimension
    }
}
