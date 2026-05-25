//
//  LocalizationManager.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation
import UIKit
import StorageKit

final class LocalizationManager {

    static let shared = LocalizationManager()

    private init() {}

    var currentLanguage: String {
        AppStorage.selectedLanguage ?? "en"
    }

    func setLanguage(_ language: String) {
        LanguageProvider.shared.setLanguage(language)
    }
}


final class LanguageProvider {

    static let shared = LanguageProvider()

    private init() {}

    private var bundle: Bundle = .main
    private let lock = NSLock()

    // MARK: - Public

    func setLanguage(_ language: String) {

        AppStorage.selectedLanguage = language

        // Persistence (next launch only)
        UserDefaults.standard.set([language], forKey: "AppleLanguages")

        // Update runtime bundle
        lock.lock()
        bundle = Self.loadBundle(for: language)
        lock.unlock()

        NotificationCenter.default.post(
            name: .languageChanged,
            object: nil
        )
    }

    func localizedString(for key: String) -> String {
        lock.lock()
        let currentBundle = bundle
        lock.unlock()

        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    // MARK: - Bundle loader

    private static func loadBundle(for language: String) -> Bundle {
        guard
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return .main
        }

        return bundle
    }
}


extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
