//
//  StatsCardRow.swift
//  
//
//  Created by Edwin Weru on 26/03/2026.
//

import DesignSystemKit
import UIKit

public final class StatsCardRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: StatsCardCell.self)
    public var cellClass: AnyClass? { StatsCardCell.self }

    private let config: StatsCardConfig

    public init(tag: Int, config: StatsCardConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? StatsCardCell else { return cell }

        cell.configure(with: config)

        //Centralized tap handling
        cell.onItemTap = { [config] id in
            config.items.first(where: { $0.id == id })?.onTap?()
        }

        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
