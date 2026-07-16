//
//  InputType.swift
//  
//
//  Created by Edwin Weru on 16/07/2026.
//

public enum InputType {
    case normal
    case email
    case password
    case phone
    case number
    case decimal
    case name
    case username

    var defaultConfig: TextFieldConfig {
        switch self {
        case .normal:
            return TextFieldConfig()

        case .email:
            return TextFieldConfig(
                keyboardType: .emailAddress,
                autoCapitalization: .none,
                textContentType: .emailAddress
            )

        case .password:
            return TextFieldConfig(
                isSecureTextEntry: true,
                textContentType: .password
            )

        case .phone:
            return TextFieldConfig(
                keyboardType: .phonePad,
                textContentType: .telephoneNumber
            )

        case .number:
            return TextFieldConfig(
                keyboardType: .numberPad
            )

        case .decimal:
            return TextFieldConfig(
                keyboardType: .decimalPad
            )

        case .name:
            return TextFieldConfig(
                autoCapitalization: .words,
                textContentType: .name
            )

        case .username:
            return TextFieldConfig(
                autoCapitalization: .none,
                textContentType: .username
            )
        }
    }
}
