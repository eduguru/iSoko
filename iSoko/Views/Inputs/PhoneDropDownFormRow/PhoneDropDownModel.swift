//
//  PhoneDropDownModel.swift
//  
//
//  Created by Edwin Weru on 07/10/2025.
//

import UIKit
import UtilsKit

public struct PhoneDropDownModel {
    public var phoneNumber: String
    public var selectedCountry: Country
    public var placeholder: String
    public var titleText: String?
    public var validation: ValidationConfiguration?

    public var cardCornerRadius: CGFloat = 8
    public var cardBorderColor: UIColor = .lightGray

    public var onPhoneChanged: ((String) -> Void)?
    public var onCountryTapped: (() -> Void)?
    public var onValidationError: ((String?) -> Void)?

    public var validationError: String?

    public init(
        phoneNumber: String = "",
        selectedCountry: Country,
        placeholder: String = "Enter phone number",
        titleText: String? = nil,
        validation: ValidationConfiguration? = nil,
        cardCornerRadius: CGFloat = 8,
        cardBorderColor: UIColor = .lightGray,
        onPhoneChanged: ((String) -> Void)? = nil,
        onCountryTapped: (() -> Void)? = nil,
        onValidationError: ((String?) -> Void)? = nil
    ) {
        self.phoneNumber = phoneNumber
        self.selectedCountry = selectedCountry
        self.placeholder = placeholder
        self.titleText = titleText
        self.validation = validation
        self.cardCornerRadius = cardCornerRadius
        self.cardBorderColor = cardBorderColor
        self.onPhoneChanged = onPhoneChanged
        self.onCountryTapped = onCountryTapped
        self.onValidationError = onValidationError
    }
}
