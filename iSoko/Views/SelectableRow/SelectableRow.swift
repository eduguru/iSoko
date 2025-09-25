//
//  SelectableRow.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit
import DesignSystemKit

public final class SelectableRow: FormRow {
    public let tag: Int

    // Toggle for card vs divider style
    public var useDividerStyle: Bool = true

    public var reuseIdentifier: String {
        return useDividerStyle
            ? String(describing: SelectableCellWithDivider.self)
            : String(describing: SelectableCell.self)
    }

    public var cellClass: AnyClass? {
        return useDividerStyle
            ? SelectableCellWithDivider.self
            : SelectableCell.self
    }

    public var config: SelectableRowConfig

    public init(tag: Int, config: SelectableRowConfig, useDividerStyle: Bool = true) {
        self.tag = tag
        self.config = config
        self.useDividerStyle = useDividerStyle
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        if useDividerStyle {
            guard let cell = cell as? SelectableCellWithDivider else {
                assertionFailure("Expected SelectableCellWithDivider")
                return cell
            }
            cell.configure(with: config)
            return cell
        } else {
            guard let cell = cell as? SelectableCell else {
                assertionFailure("Expected SelectableCell")
                return cell
            }
            cell.configure(with: config)
            return cell
        }
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
