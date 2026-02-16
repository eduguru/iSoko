//
//  QuantityFormRow.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit

final class QuantityFormRow: FormRow {

    let tag: Int
    let reuseIdentifier: String = QuantityStepperCell.reuseIdentifier
    let cellClass: AnyClass? = QuantityStepperCell.self

    private let title: String
    private let initialValue: Int
    private let onValueChanged: ((Int) -> Void)?

    init(tag: Int,
         title: String,
         initialValue: Int = 1,
         onValueChanged: ((Int) -> Void)? = nil) {
        self.tag = tag
        self.title = title
        self.initialValue = initialValue
        self.onValueChanged = onValueChanged
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? QuantityStepperCell else { return cell }
        cell.configure(title: title, initialValue: initialValue)

        cell.onValueChanged = { [weak self] value in
            self?.onValueChanged?(value)
        }

        return cell
    }

    @MainActor
    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        64 // fixed height, tweak as needed
    }
}
