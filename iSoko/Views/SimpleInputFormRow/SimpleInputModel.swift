//
//  SimpleInputModel.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

public enum CardStyle {
    case none
    case border
    case shadow
    case borderAndShadow
}

public struct SimpleInputModel {
    public var text: String
    public var config: TextFieldConfig
    public var validation: ValidationConfiguration?

    // Optional title above the input field
    public var titleText: String?

    // Card styling
    public var useCardStyle: Bool
    public var cardStyle: CardStyle
    public var cardCornerRadius: CGFloat
    public var cardBorderColor: UIColor
    public var cardShadowColor: UIColor

    // Callbacks
    public var onTextChanged: ((String) -> Void)?
    public var onValidationError: ((String?) -> Void)?
    public var onReturnKeyTapped: (() -> Void)?

    // Internal validation result
    public var validationError: String?

    // MARK: - Init

    public init(
        text: String = "",
        config: TextFieldConfig = TextFieldConfig(),
        validation: ValidationConfiguration? = nil,
        titleText: String? = nil,
        useCardStyle: Bool = false,
        cardStyle: CardStyle = .border,
        cardCornerRadius: CGFloat = 8,
        cardBorderColor: UIColor = .lightGray,
        cardShadowColor: UIColor = .black,
        onTextChanged: ((String) -> Void)? = nil,
        onValidationError: ((String?) -> Void)? = nil,
        onReturnKeyTapped: (() -> Void)? = nil
    ) {
        self.text = text
        self.config = config
        self.validation = validation
        self.titleText = titleText
        self.useCardStyle = useCardStyle
        self.cardStyle = cardStyle
        self.cardCornerRadius = cardCornerRadius
        self.cardBorderColor = cardBorderColor
        self.cardShadowColor = cardShadowColor
        self.onTextChanged = onTextChanged
        self.onValidationError = onValidationError
        self.onReturnKeyTapped = onReturnKeyTapped
    }

    // MARK: - Validation

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
