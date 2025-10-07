//
//  PhoneDropDownFormRow.swift
//  
//
//  Created by Edwin Weru on 07/10/2025.
//

import UIKit
import DesignSystemKit

public final class PhoneDropDownFormRow: FormRow {
    public let tag: Int
    public var model: PhoneDropDownModel

    public var reuseIdentifier: String { "PhoneDropDownFormCell" }
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { String(tag) }
    public var cellClass: AnyClass? { PhoneDropDownFormCell.self }

    private var hasValidated = false

    public init(tag: Int, model: PhoneDropDownModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let phoneCell = cell as? PhoneDropDownFormCell else { return cell }

        phoneCell.configure(with: model)

        phoneCell.onPhoneChanged = { [weak self] newText in
            self?.model.phoneNumber = newText
            self?.model.onPhoneChanged?(newText)
            if self?.hasValidated == true {
                self?.validate()
                phoneCell.setError(self?.model.validationError)
            }
        }

        phoneCell.onCountryTapped = { [weak self] in
            self?.model.onCountryTapped?()
        }

        return phoneCell
    }

    public func validate() -> Bool {
        hasValidated = true
        model.validationError = model.validation?.validate(model.phoneNumber)
        model.onValidationError?(model.validationError)
        return model.validationError == nil
    }

    public func validateWithError() -> Bool {
        return validate()
    }

    public func reset() {
        model.phoneNumber = ""
        model.validationError = nil
    }

    public func fieldVisibility() -> Bool {
        return true
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
