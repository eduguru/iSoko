//
//  TextFieldConfig.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

public struct TextFieldConfig {
    public var placeholder: String?
    public var keyboardType: UIKeyboardType?
    public var isReadOnly: Bool
    public var isSecureTextEntry: Bool
    public var accessoryImage: UIImage?
    public var prefixText: String?
    public var returnKeyType: UIReturnKeyType?
    public var autoCapitalization: UITextAutocapitalizationType?
    public var textContentType: UITextContentType?

    // Optional Enhancements
    public var textAlignment: NSTextAlignment?
    public var textFont: UIFont?
    public var textColor: UIColor?
    public var maxCharacterCount: Int?

    public init(
        placeholder: String? = nil,
        keyboardType: UIKeyboardType? = nil,
        isReadOnly: Bool = false,
        isSecureTextEntry: Bool = false,
        accessoryImage: UIImage? = nil,
        prefixText: String? = nil,
        returnKeyType: UIReturnKeyType? = nil,
        autoCapitalization: UITextAutocapitalizationType? = nil,
        textContentType: UITextContentType? = nil,
        textAlignment: NSTextAlignment? = nil,
        textFont: UIFont? = nil,
        textColor: UIColor? = nil,
        maxCharacterCount: Int? = nil
    ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isReadOnly = isReadOnly
        self.isSecureTextEntry = isSecureTextEntry
        self.accessoryImage = accessoryImage
        self.prefixText = prefixText
        self.returnKeyType = returnKeyType
        self.autoCapitalization = autoCapitalization
        self.textContentType = textContentType
        self.textAlignment = textAlignment
        self.textFont = textFont
        self.textColor = textColor
        self.maxCharacterCount = maxCharacterCount
    }
}

extension TextFieldConfig {

    func merged(with override: TextFieldConfig) -> TextFieldConfig {
        var config = self

        config.placeholder = override.placeholder ?? config.placeholder
        config.keyboardType = override.keyboardType ?? config.keyboardType
        config.isReadOnly = override.isReadOnly
        config.isSecureTextEntry = override.isSecureTextEntry
        config.accessoryImage = override.accessoryImage ?? config.accessoryImage
        config.prefixText = override.prefixText ?? config.prefixText
        config.returnKeyType = override.returnKeyType ?? config.returnKeyType
        config.autoCapitalization = override.autoCapitalization ?? config.autoCapitalization
        config.textContentType = override.textContentType ?? config.textContentType
        config.textAlignment = override.textAlignment ?? config.textAlignment
        config.textFont = override.textFont ?? config.textFont
        config.textColor = override.textColor ?? config.textColor
        config.maxCharacterCount = override.maxCharacterCount ?? config.maxCharacterCount

        return config
    }
}
