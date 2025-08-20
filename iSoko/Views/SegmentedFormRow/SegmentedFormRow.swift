//
//  SegmentedFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import DesignSystemKit
import UIKit

public class SegmentedFormRow: FormRow {
    
    public var model: SegmentedFormModel
    
    public init(model: SegmentedFormModel) {
        self.model = model
    }

    public var reuseIdentifier: String {
        return "SegmentedControlCell"
    }

    public var tag: Int {
        return model.tag
    }

    public var cellClass: AnyClass? {
        return SegmentedControlCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? SegmentedControlCell else { return cell }
        cell.configure(with: model)

        cell.onValueChanged = { [weak self] newIndex in
            self?.model.selectedIndex = newIndex
            self?.model.onSelectionChanged?(newIndex) // 🔥 callback invoked
        }

        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 80 // Or UITableView.automaticDimension
    }
}
