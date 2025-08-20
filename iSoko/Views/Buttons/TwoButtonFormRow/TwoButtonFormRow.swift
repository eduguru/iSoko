//
//  TwoButtonFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UIKit

public final class TwoButtonFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: TwoButtonFormCell.self)
    public var cellClass: AnyClass? { TwoButtonFormCell.self }

    public var button1Model: ButtonFormModel
    public var button2Model: ButtonFormModel
    public var layout: MultiButtonFormModel.Layout // Layout for buttons (vertical or horizontal)

    public init(tag: Int, button1Model: ButtonFormModel, button2Model: ButtonFormModel, layout: MultiButtonFormModel.Layout = .vertical()) {
        self.tag = tag
        self.button1Model = button1Model
        self.button2Model = button2Model
        self.layout = layout
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let buttonCell = cell as? TwoButtonFormCell else {
            assertionFailure("Expected TwoButtonFormCell")
            return cell
        }

        buttonCell.configure(with: button1Model, button2Model: button2Model, layout: layout)

        return buttonCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        let buttonHeight = button1Model.size.height // Assuming both buttons have the same height
        return buttonHeight + 24 // Add vertical padding
    }
}
