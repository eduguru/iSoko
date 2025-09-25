//
//  LocalizationManager.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation
import StorageKit

//public final class LocalizationManager {
//    private static var _language: String = "en"
//
//    private init() {}
//
//    public static var currentLanguage: String {
//        get { AppStorage.currentLanguage ?? _language }
//        set { AppStorage.currentLanguage = newValue }
//    }
//}

import Foundation
import StorageKit

public final class LocalizationManager {
    private init() {}
    
    // MARK: - Supported Languages
    public static let supportedLanguages: [String] = ["en", "sw", "fr"]
    
    // MARK: - Default Language
    private static let defaultLanguage = "en"
    
    // MARK: - Notification
    public static let languageDidChangeNotification = Notification.Name("LocalizationManager.languageDidChange")
    
    // MARK: - Persisted or fallback language
    private static var _language: String = defaultLanguage
    
    public static var currentLanguage: String {
        get {
            if let stored = AppStorage.selectedLanguage,
               supportedLanguages.contains(stored) {
                return stored
            }
            return resolvedSystemLanguage()
        }
        set {
            guard newValue != currentLanguage else { return } // Only trigger if changed
            AppStorage.selectedLanguage = newValue
            NotificationCenter.default.post(name: languageDidChangeNotification, object: nil)
        }
    }
    
    /// Resolves the system-preferred language if supported
    public static func resolvedSystemLanguage() -> String {
        guard let preferred = Locale.preferredLanguages.first else {
            return defaultLanguage
        }
        
        let code = String(preferred.prefix(2))
        return supportedLanguages.contains(code) ? code : defaultLanguage
    }
}
