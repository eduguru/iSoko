//
//  ValidationConfiguration.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

public struct ValidationConfiguration {
    public var isRequired: Bool
    public var minLength: Int?
    public var maxLength: Int?
    public var errorMessageRequired: String?
    public var errorMessageLength: String?

    // Existing init...
    
    public init(
        isRequired: Bool = false,
        minLength: Int? = nil,
        maxLength: Int? = nil,
        errorMessageRequired: String? = nil,
        errorMessageLength: String? = nil
    ) {
        self.isRequired = isRequired
        self.minLength = minLength
        self.maxLength = maxLength
        self.errorMessageRequired = errorMessageRequired
        self.errorMessageLength = errorMessageLength
    }

    /// Validates the given text according to the config, returns error string if invalid or nil if valid
    public func validate(_ text: String) -> String? {
        // Check required
        if isRequired && text.isEmpty {
            return errorMessageRequired ?? "This field is required."
        }
        
        // Check min length
        if let minLength = minLength, text.count < minLength {
            return errorMessageLength ?? "Minimum length is \(minLength)."
        }
        
        // Check max length
        if let maxLength = maxLength, text.count > maxLength {
            return errorMessageLength ?? "Maximum length is \(maxLength)."
        }
        
        // Valid
        return nil
    }
}
