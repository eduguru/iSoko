//
//  HubCardRow.swift
//  
//
//  Created by Edwin Weru on 18/03/2026.
//

import DesignSystemKit
import UIKit

// MARK: - HubCardRow

public final class HubCardRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: HubCardCell.self)
    public var cellClass: AnyClass? { HubCardCell.self }

    private let config: HubCardConfig

    public init(tag: Int, config: HubCardConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? HubCardCell else { return cell }
        cell.configure(with: config)

        // ✅ Wire tap callback from cell to row, then trigger action's closure
        cell.onActionTap = { [config] actionId in
            if let action = config.actions.first(where: { $0.id == actionId }) {
                action.onTap?()
            }
        }

        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
