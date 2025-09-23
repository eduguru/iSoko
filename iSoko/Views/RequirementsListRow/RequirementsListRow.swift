//
//  RequirementsListRow.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit

public final class RequirementsListRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: RequirementsListCell.self)
    public var cellClass: AnyClass? { RequirementsListCell.self }

    public var config: RequirementsListRowConfig

    public init(tag: Int, config: RequirementsListRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? RequirementsListCell else {
            assertionFailure("Expected RequirementsListCell")
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
