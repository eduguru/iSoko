//
//  String+Localization.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation

public extension String {

    var localized: String {
        let value = LanguageProvider.shared.localizedString(for: self)

        #if DEBUG
        return value
        #else
        return value == self ? englishFallback : value
        #endif
    }

    private var englishFallback: String {
        guard
            let path = Bundle.main.path(forResource: "en", ofType: "lproj") ??
                       Bundle.main.path(forResource: "Base", ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return self
        }

        return bundle.localizedString(forKey: self, value: self, table: nil)
    }

    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }

    func localizedPlural(count: Int) -> String {
        String.localizedStringWithFormat(localized, count)
    }

    func localized(namedParameters: [String: String]) -> String {
        var result = localized

        for (key, value) in namedParameters {
            result = result.replacingOccurrences(of: "%{\(key)}", with: value)
        }

        return result
    }
}
