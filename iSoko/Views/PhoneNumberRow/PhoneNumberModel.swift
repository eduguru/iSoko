//
//  PhoneNumberModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import Foundation
import PhoneNumberKit

public class PhoneNumberModel {
    private var phoneNumberKit = PhoneNumberUtility()
    
    var phoneNumber: String?
    var isValid: Bool = false
    
    // Customizable properties
    var defaultRegion: String = "KE"   // Default to Kenya (can be customized)
    var withFlag: Bool = true          // Show flag by default
    var placeholder: String = "Enter phone number"  // Default placeholder text
    
    public init(
        phoneNumberKit: PhoneNumberUtility = PhoneNumberUtility(),
        phoneNumber: String? = nil,
        isValid: Bool = false,
        defaultRegion: String = "KE",
        withFlag: Bool = true,
        placeholder: String = "Enter phone number") {
            
        self.phoneNumberKit = phoneNumberKit
        self.phoneNumber = phoneNumber
        self.isValid = isValid
        self.defaultRegion = defaultRegion
        self.withFlag = withFlag
        self.placeholder = placeholder
    }
    
    // Method to validate phone number
    public func validatePhoneNumber() {
        do {
            _ = try phoneNumberKit.parse(phoneNumber ?? "")
            isValid = true
        } catch {
            isValid = false
        }
    }
    
    // Optional method to reset the phone number
    public func reset() {
        phoneNumber = nil
        isValid = false
    }
}
