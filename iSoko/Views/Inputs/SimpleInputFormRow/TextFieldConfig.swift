//
//  TextFieldConfig.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

public struct TextFieldConfig {
    public var placeholder: String?
    public var keyboardType: UIKeyboardType
    public var isReadOnly: Bool
    public var isSecureTextEntry: Bool
    public var accessoryImage: UIImage?
    public var prefixText: String?
    public var returnKeyType: UIReturnKeyType
    public var autoCapitalization: UITextAutocapitalizationType
    public var textContentType: UITextContentType?

    // Optional Enhancements
    public var textAlignment: NSTextAlignment
    public var textFont: UIFont?
    public var textColor: UIColor?
    public var maxCharacterCount: Int?

    public init(
        placeholder: String? = nil,
        keyboardType: UIKeyboardType = .default,
        isReadOnly: Bool = false,
        isSecureTextEntry: Bool = false,
        accessoryImage: UIImage? = nil,
        prefixText: String? = nil,
        returnKeyType: UIReturnKeyType = .default,
        autoCapitalization: UITextAutocapitalizationType = .none,
        textContentType: UITextContentType? = nil,
        textAlignment: NSTextAlignment = .natural,
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
