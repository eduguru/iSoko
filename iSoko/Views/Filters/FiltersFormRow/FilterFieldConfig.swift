//
//  FilterFieldConfig.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

// MARK: - Field Config
public struct FilterFieldConfig {

    public let placeholder: String
    public let selectedValue: String?

    public let iconSystemName: String?   // ✅ custom trailing icon

    public let onTap: (() -> Void)?

    public let showsClearButton: Bool
    public let onClear: (() -> Void)?

    public init(
        placeholder: String,
        selectedValue: String? = nil,
        iconSystemName: String? = nil,
        onTap: (() -> Void)?,
        showsClearButton: Bool = false,
        onClear: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.selectedValue = selectedValue
        self.iconSystemName = iconSystemName
        self.onTap = onTap
        self.showsClearButton = showsClearButton
        self.onClear = onClear
    }
}
