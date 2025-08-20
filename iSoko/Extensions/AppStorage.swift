//
//  AppStorage.swift
//  iSoko
//
//  Created by Edwin Weru on 17/07/2025.
//

import Foundation
import StorageKit

public extension StorageKeys.Keychain {
    static let userProfile = "\(AppStorage.prefix)userProfile"
    
    static let authToken = "\(AppStorage.prefix)authToken"
    static let accessToken = "\(AppStorage.prefix)accessToken"
    static let refreshToken = "\(AppStorage.prefix)refreshToken"
    static let tokenExpiry = "\(AppStorage.prefix)tokenExpiry"
}

public extension StorageKeys.UserDefaults {
    static let isBiometricsEnabled = "\(AppStorage.prefix)isBiometricsEnabled"
    static let currentLanguage = "\(AppStorage.prefix)currentLanguage"
    static let selectedRegion = "\(AppStorage.prefix)selectedRegion"
}

extension AppStorage {
    
    //MARK: KeychainStored
    @KeychainStored(StorageKeys.Keychain.userProfile)
    public static var userProfile: String?
    
    //MARK: UserDefault
    @UserDefault(StorageKeys.UserDefaults.currentLanguage)
    public static var currentLanguage: String?
    
    @UserDefault(StorageKeys.UserDefaults.selectedRegion)
    public static var selectedRegion: String?
    
    @UserDefault(StorageKeys.UserDefaults.isBiometricsEnabled)
    public static var isBiometricsEnabled: Bool?
    
    @KeychainStored(StorageKeys.Keychain.authToken)
    public static var authToken: TokenModel?
    
    @KeychainStored(StorageKeys.Keychain.accessToken)
    public static var accessToken: String?
    
    @KeychainStored(StorageKeys.Keychain.refreshToken)
    public static var refreshToken: String?
    
    @UserDefault(StorageKeys.Keychain.tokenExpiry)
    public static var tokenExpiry: Date?
}
