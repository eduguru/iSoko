//
//  TimeframeSelectorRow.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit
import DesignSystemKit

// MARK: - FormRow integration
public final class TimeframeSelectorRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: TimeframeSelectorCell.self)
    public var cellClass: AnyClass? { TimeframeSelectorCell.self }

    public var config: TimeframeSelectorConfig

    /// Called with the selected index (single selection mode)
    public var onSelectionChanged: ((Int) -> Void)?

    /// Called when the custom option is tapped
    public var onCustomSelected: (() -> Void)?

    public init(tag: Int, config: TimeframeSelectorConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TimeframeSelectorCell else { return cell }
        cell.configure(with: config)

        // Map the cell's Set<Int> back to single index if needed
        cell.onSelectionChanged = { [weak self] selectedIndices in
            guard let self = self else { return }

            if let index = selectedIndices.first {
                self.config.selectedIndex = index
                self.onSelectionChanged?(index)

                // Call custom option handler if "Custom" is tapped
                if self.config.options[index].title.lowercased() == "custom" {
                    self.onCustomSelected?()
                }
            } else {
                self.config.selectedIndex = nil
            }
        }

        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
