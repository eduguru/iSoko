//
//  String+Localization.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation

public extension String {

    /// Main entry point you already use everywhere
    var localized: String {
        let value = NSLocalizedString(self, comment: "")

        #if DEBUG
        // In DEBUG: be strict so you catch missing translations early
        return value

        #else
        // In RELEASE: fallback to English if missing
        if value == self {
            return englishFallback
        }
        return value
        #endif
    }

    /// MARK: - English fallback (Release only use)
    private var englishFallback: String {
        guard
            let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return self
        }

        return bundle.localizedString(forKey: self, value: self, table: nil)
    }

    /// MARK: - Format arguments
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }

    /// MARK: - Plural support
    func localizedPlural(count: Int) -> String {
        String.localizedStringWithFormat(localized, count)
    }

    /// MARK: - Named parameters replacement
    func localized(namedParameters: [String: String]) -> String {
        var result = localized

        for (key, value) in namedParameters {
            result = result.replacingOccurrences(of: "%{\(key)}", with: value)
        }

        return result
    }
}
