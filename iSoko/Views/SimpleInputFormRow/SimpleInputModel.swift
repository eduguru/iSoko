//
//  SimpleInputModel.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

public struct SimpleInputModel {
    public var text: String
    public var config: TextFieldConfig
    public var validation: ValidationConfiguration?

    public var onTextChanged: ((String) -> Void)?
    public var onValidationError: ((String?) -> Void)?
    public var onReturnKeyTapped: (() -> Void)?

    // Internal validation result
    public var validationError: String?

    public init(
        text: String = "",
        config: TextFieldConfig = TextFieldConfig(),
        validation: ValidationConfiguration? = nil,
        onTextChanged: ((String) -> Void)? = nil,
        onValidationError: ((String?) -> Void)? = nil,
        onReturnKeyTapped: (() -> Void)? = nil
    ) {
        self.text = text
        self.config = config
        self.validation = validation
        self.onTextChanged = onTextChanged
        self.onValidationError = onValidationError
        self.onReturnKeyTapped = onReturnKeyTapped
    }

    /// Perform validation based on ValidationConfiguration
    @discardableResult
    public mutating func validate() -> Bool {
        validationError = nil

        guard let validation = validation else {
            onValidationError?(nil)
            return true
        }

        // Check required
        if validation.isRequired && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationError = validation.errorMessageRequired ?? "This field is required."
            onValidationError?(validationError)
            return false
        }

        // Check min length
        if let minLen = validation.minLength, text.count < minLen {
            validationError = validation.errorMessageLength ?? "Must be at least \(minLen) characters."
            onValidationError?(validationError)
            return false
        }

        // Check max length
        if let maxLen = validation.maxLength, text.count > maxLen {
            validationError = validation.errorMessageLength ?? "Must be at most \(maxLen) characters."
            onValidationError?(validationError)
            return false
        }

        onValidationError?(nil)
        return true
    }
}
