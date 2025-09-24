//
//  Language.swift
//  
//
//  Created by Edwin Weru on 18/09/2025.
//

import Foundation

public struct Language: Equatable, Hashable {
    public let code: String    // e.g. "en", "fr", "sw"
    public let name: String    // e.g. "English", "Français", "Kiswahili"

    // Optional convenience initializer from code only
    public init(code: String) {
        self.code = code
        self.name = Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code
    }

    // Preferred init when you want full control
    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}
