//
//  Notification+Name.swift
//  
//
//  Created by Edwin Weru on 10/02/2026.
//

import Foundation

// MARK: - Notification
public extension Notification.Name {
    // static let didLogoutDueToAuthFailure = Notification.Name("didLogoutDueToAuthFailure")
    static let authTokenExpired = Notification.Name("AuthTokenExpired")

    static let languageDidChangeNotification = Notification.Name("LocalizationManager.languageDidChange")
}

//NotificationCenter.default.addObserver(
//    forName: .didLogoutDueToAuthFailure,
//    object: nil,
//    queue: .main
//) { _ in
//    // Navigate to login / reset app state
//}
