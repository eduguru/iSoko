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
    public let reuseIdentifier: String = String(describing: SelectableCell.self)
    public var cellClass: AnyClass? { SelectableCell.self }

    public var config: SelectableRowConfig

    public init(tag: Int, config: SelectableRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? SelectableCell else {
            assertionFailure("Expected SelectableCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
