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

        // 1. Save as source of truth
        AppStorage.selectedLanguage = language

        // 2. IMPORTANT: Tell iOS to use it
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // 3. Notify UI
        NotificationCenter.default.post(
            name: .languageChanged,
            object: nil
        )

    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
