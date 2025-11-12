//
//  LongInputDescriptionModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

public struct LongInputDescriptionModel {
    public var text: String
    public var config: TextViewConfig
    public var validation: ValidationConfiguration?
    public var titleText: String?
    
    // Card Style
    public var useCardStyle: Bool
    public var cardStyle: CardStyle
    public var cardCornerRadius: CGFloat
    public var cardBorderColor: UIColor
    public var cardShadowColor: UIColor
    
    // Callbacks
    public var onTextChanged: ((String) -> Void)?
    public var onValidationError: ((String?) -> Void)?
    
    public var validationError: String?

    public init(
        text: String = "",
        config: TextViewConfig = TextViewConfig(),
        validation: ValidationConfiguration? = nil,
        titleText: String? = nil,
        useCardStyle: Bool = false, // Added to model
        cardStyle: CardStyle = .border,
        cardCornerRadius: CGFloat = 8,
        cardBorderColor: UIColor = .lightGray,
        cardShadowColor: UIColor = .black,
        onTextChanged: ((String) -> Void)? = nil,
        onValidationError: ((String?) -> Void)? = nil
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
    }

    public mutating func validate() -> Bool {
        var isValid = true
        if let validation = validation {
            if validation.isRequired && text.isEmpty {
                validationError = validation.errorMessageRequired ?? "This field is required"
                isValid = false
            }
            if let minLength = validation.minLength, text.count < minLength {
                validationError = validation.errorMessageLength ?? "Minimum length is \(minLength)"
                isValid = false
            }
            if let maxLength = validation.maxLength, text.count > maxLength {
                validationError = validation.errorMessageLength ?? "Maximum length is \(maxLength)"
                isValid = false
            }
        }
        return isValid
    }
}
