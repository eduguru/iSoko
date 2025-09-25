//
//  LanguageHelper.swift
//  
//
//  Created by Edwin Weru on 18/09/2025.
//

import Foundation

final class LanguageHelper {
    static let shared = LanguageHelper()

    /// Manually controlled list of supported app languages
    let supportedLanguages: [Language] = [
        Language(code: "en", name: "English"),
        Language(code: "fr", name: "Français"),
        Language(code: "sw", name: "Kiswahili"),
        Language(code: "rw", name: "Kinyarwanda"),
        Language(code: "rn", name: "Rundi"),
        // Language(code: "ar", name: "العربية")
        // Add or remove as needed
    ]

    /// Look up a language by its code
    func language(for code: String) -> Language? {
        supportedLanguages.first { $0.code == code }
    }

    /// Optional: Detect system-supported `.lproj` folders in the bundle
    func availableLocalizationsFromBundle() -> [Language] {
        return Bundle.main.localizations
            .filter { $0 != "Base" } // optional: exclude "Base"
            .map { Language(code: $0) }
    }
}
