//
//  EventScheduleRow.swift
//  
//
//  Created by Edwin Weru on 03/08/2026.
//

import UIKit
import DesignSystemKit

final class EventScheduleRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: EventScheduleCell.self)
    public var cellClass: AnyClass? { EventScheduleCell.self }
    public let config: EventScheduleCellConfig

    public init(tag: Int, config: EventScheduleCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        guard let cell = cell as? EventScheduleCell else {
            assertionFailure("Expected EventScheduleCell")
            return cell
        }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
