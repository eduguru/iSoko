//
//  ButtonFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class ButtonFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: ButtonFormCell.self)
    public var cellClass: AnyClass? { ButtonFormCell.self }

    public var model: ButtonFormModel

    public init(tag: Int, model: ButtonFormModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let buttonCell = cell as? ButtonFormCell else {
            assertionFailure("Expected ButtonFormCell")
            return cell
        }

        buttonCell.configure(with: model)

        return buttonCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        model.size.height + 24 // Add some vertical padding
    }
}
