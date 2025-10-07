//
//  SimpleInputFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import DesignSystemKit
import UIKit

public final class SimpleInputFormRow: FormRow {
    public let tag: Int
    public var model: SimpleInputModel

    public var reuseIdentifier: String { "SimpleInputFormCell" }
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { String(tag) }
    public var nibName: String? { nil }
    public var cellClass: AnyClass? { SimpleInputFormCell.self }

    private var hasValidated = false

    public init(tag: Int, model: SimpleInputModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let inputCell = cell as? SimpleInputFormCell else { return cell }
        inputCell.configure(with: model)
        inputCell.onTextChanged = { [weak self] newText in
            self?.model.text = newText
            self?.model.onTextChanged?(newText)
            if self?.hasValidated == true {
                self?.validate()
                inputCell.setError(self?.model.validationError)
            }
        }
        return inputCell
    }

    public func validate() -> Bool {
        hasValidated = true
        model.validationError = validateText(model.text, with: model.validation)
        model.onValidationError?(model.validationError)
        return model.validationError == nil
    }

    public func validateWithError() -> Bool {
        validate()
    }

    public func reset() {
        model.text = ""
        model.validationError = nil
    }

    public func fieldVisibility() -> Bool {
        true
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 80
    }

    private func validateText(_ text: String, with config: ValidationConfiguration?) -> String? {
        guard let config else { return nil }

        if config.isRequired && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return config.errorMessageRequired ?? "This field is required"
        }

        if let min = config.minLength, text.count < min {
            return config.errorMessageLength ?? "Minimum \(min) characters"
        }

        if let max = config.maxLength, text.count > max {
            return config.errorMessageLength ?? "Maximum \(max) characters"
        }

        return nil
    }
}
