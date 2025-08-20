//
//  String+Localization.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation

extension String {

    /// Localized string using the current language from `LocalizationManager`
    var localized: String {
        localized(for: LocalizationManager.currentLanguage)
    }

    /// Returns a localized string for the specified language, with fallback.
    func localized(for language: String, fallbackLanguage: String = "en") -> String {
        if #available(iOS 15.0, macOS 12.0, *) {
            if let bundle = Self.bundle(for: language) ?? Self.bundle(for: fallbackLanguage) {
                return String(localized: String.LocalizationValue(self), bundle: bundle, comment: "")
            } else {
                return String(localized: String.LocalizationValue(self), bundle: .main, comment: "")
            }
        } else {
            let bundle = Self.bundle(for: language)
                ?? Self.bundle(for: fallbackLanguage)
                ?? .main
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
    }

    /// Formats localized string with variadic arguments
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }

    /// Formats localized string with an array of arguments
    func localized(arguments: [CVarArg]) -> String {
        String(format: localized, arguments: arguments)
    }

    /// Returns a pluralized localized string for a count
    func localizedPlural(count: Int) -> String {
        String.localizedStringWithFormat(localized, count)
    }

    /// Replaces named parameters in localized string, e.g. `%{username}`
    func localized(namedParameters: [String: String]) -> String {
        var result = localized
        for (key, value) in namedParameters {
            result = result.replacingOccurrences(of: "%{\(key)}", with: value)
        }
        return result
    }

    // MARK: - Bundle Loader

    private static func bundle(for language: String) -> Bundle? {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return nil
        }
        return Bundle(path: path)
    }
}
