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
    
    // Replace fixed reuseIdentifier with this to allow swap
    public var useExternalTitleCell: Bool = true
    
    public var reuseIdentifier: String {
        return useExternalTitleCell
            ? String(describing: DropdownFormCellWithExternalTitle.self)
            : String(describing: DropdownFormCell.self)
    }
    
    public var cellClass: AnyClass? {
        return useExternalTitleCell
            ? DropdownFormCellWithExternalTitle.self
            : DropdownFormCell.self
    }

    public var config: DropdownFormConfig
    private var isValid: Bool = true

    public init(tag: Int, config: DropdownFormConfig, useExternalTitleCell: Bool = true) {
        self.tag = tag
        self.config = config
        self.useExternalTitleCell = useExternalTitleCell
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        if useExternalTitleCell {
            guard let cell = cell as? DropdownFormCellWithExternalTitle else {
                assertionFailure("Expected DropdownFormCellWithExternalTitle")
                return cell
            }
            if !isValid {
                config.subtitle = "This field is required"
            }
            cell.configure(with: config)
            return cell
        } else {
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
