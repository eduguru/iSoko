//
//  DropdownFormRow.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import UIKit
import DesignSystemKit

public final class DropdownFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: DropdownFormCell.self)
    public var cellClass: AnyClass? { DropdownFormCell.self }

    public var config: DropdownFormConfig
    private var isValid: Bool = true

    public init(tag: Int, config: DropdownFormConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? DropdownFormCell else {
            assertionFailure("Expected DropdownFormCell")
            return cell
        }

        if !isValid {
            config.subtitle = "This field is required"
        }

        cell.configure(with: config)
        return cell
    }

    public func updateValue(_ value: String) {
        config.value = value
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool {
        isValid = config.value?.isEmpty == false
        return isValid
    }

    public func validateWithError() -> Bool {
        isValid = config.value?.isEmpty == false
        return isValid
    }

    public func reset() {
        config.value = nil
        config.subtitle = nil
        isValid = true
    }

    public func fieldVisibility() -> Bool { true }
}
