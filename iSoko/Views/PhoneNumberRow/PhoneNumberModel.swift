//
//  PhoneNumberModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import PhoneNumberKit
import UIKit

public class PhoneNumberModel {
    private var phoneNumberKit = PhoneNumberUtility()
    
    var phoneNumber: String? {
        didSet {
            onPhoneNumberChanged?(phoneNumber)
        }
    }
    var isValid: Bool = false
    
    // Customizable properties
    var defaultRegion: String = "KE"
    var withFlag: Bool = true
    var placeholder: String = "Enter phone number"

    // Card styling options
    public var useCardStyle: Bool = true
    public var cardStyle: CardStyle = .shadow
    public var cardCornerRadius: CGFloat = 10
    public var cardBorderColor: UIColor = UIColor.lightGray
    public var cardShadowColor: UIColor = UIColor.black.withAlphaComponent(0.1)

    // ✅ Callback closure
    public var onPhoneNumberChanged: ((String?) -> Void)?

    public init(
        phoneNumberKit: PhoneNumberUtility = PhoneNumberUtility(),
        phoneNumber: String? = nil,
        isValid: Bool = false,
        defaultRegion: String = "KE",
        withFlag: Bool = true,
        placeholder: String = "Enter phone number",
        useCardStyle: Bool = true,
        cardStyle: CardStyle = .shadow,
        cardCornerRadius: CGFloat = 10,
        cardBorderColor: UIColor = UIColor.lightGray,
        cardShadowColor: UIColor = UIColor.black.withAlphaComponent(0.1),
        onPhoneNumberChanged: ((String?) -> Void)? = nil
    ) {
        self.phoneNumberKit = phoneNumberKit
        self.phoneNumber = phoneNumber
        self.isValid = isValid
        self.defaultRegion = defaultRegion
        self.withFlag = withFlag
        self.placeholder = placeholder
        self.useCardStyle = useCardStyle
        self.cardStyle = cardStyle
        self.cardCornerRadius = cardCornerRadius
        self.cardBorderColor = cardBorderColor
        self.cardShadowColor = cardShadowColor
        self.onPhoneNumberChanged = onPhoneNumberChanged
    }

    public func validatePhoneNumber() {
        do {
            _ = try phoneNumberKit.parse(phoneNumber ?? "")
            isValid = true
        } catch {
            isValid = false
        }
    }

    public func reset() {
        phoneNumber = nil
        isValid = false
    }
}
