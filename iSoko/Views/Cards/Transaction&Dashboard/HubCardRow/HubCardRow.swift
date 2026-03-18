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
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
