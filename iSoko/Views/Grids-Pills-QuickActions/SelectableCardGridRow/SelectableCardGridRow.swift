//
//  SelectableCardGridRow.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import DesignSystemKit
import UIKit

// MARK: - SelectableCardGridRow
public final class SelectableCardGridRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: SelectableCardGridCell.self)
    public var cellClass: AnyClass? { SelectableCardGridCell.self }
    public let config: SelectableCardGridConfig

    public init(tag: Int, config: SelectableCardGridConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? SelectableCardGridCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
