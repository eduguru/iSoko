//
//  InfoPairFormRow.swift
//  
//
//  Created by Edwin Weru on 04/08/2026.
//

import DesignSystemKit
import UIKit

// MARK: - FormRow

public final class InfoPairFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier = String(describing: InfoPairCell.self)
    public var cellClass: AnyClass? { InfoPairCell.self }

    public let config: InfoPairConfig

    public init(tag: Int, config: InfoPairConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        guard let cell = cell as? InfoPairCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
