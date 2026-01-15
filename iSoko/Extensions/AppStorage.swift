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
    static let userResponseObject = "\(AppStorage.prefix)userResponseObject"
    
    static let authToken = "\(AppStorage.prefix)authToken"
    static let accessToken = "\(AppStorage.prefix)accessToken"
    static let refreshToken = "\(AppStorage.prefix)refreshToken"
    static let tokenExpiry = "\(AppStorage.prefix)tokenExpiry"
}

public extension StorageKeys.UserDefaults {
    static let isBiometricsEnabled = "\(AppStorage.prefix)isBiometricsEnabled"
    static let selectedLanguage = "\(AppStorage.prefix)selectedLanguage"
    static let selectedRegion = "\(AppStorage.prefix)selectedRegion"
    static let selectedRegionCode = "\(AppStorage.prefix)selectedRegionCode"
    static let selectedCountryCode = "\(AppStorage.prefix)selectedCountryCode"
    
    static let hasSelectedLanguage = "\(AppStorage.prefix)hasSelectedLanguage"
    static let hasSelectedRegion = "\(AppStorage.prefix)hasSelectedRegion"
    static let hasViewedWalkthrough = "\(AppStorage.prefix)hasViewedWalkthrough"
    static let hasShownInitialLoginOptions = "\(AppStorage.prefix)hasShownInitialLoginOptions"
}

extension AppStorage {
    
    //MARK: KeychainStored
    @KeychainStored(StorageKeys.Keychain.userProfile)
    public static var userProfile: String?
    @KeychainStored(StorageKeys.Keychain.userResponseObject)
    public static var userResponseObject: UserV1Response?
    
    //MARK: UserDefault
    @UserDefault(StorageKeys.UserDefaults.selectedLanguage)
    public static var selectedLanguage: String?
    
    @UserDefault(StorageKeys.UserDefaults.selectedRegion)
    public static var selectedRegion: String?
    
    @UserDefault(StorageKeys.UserDefaults.selectedRegionCode)
    public static var selectedRegionCode: String?
    
    @UserDefault(StorageKeys.UserDefaults.selectedCountryCode)
    public static var selectedCountryCode: String?
    
    @UserDefault(StorageKeys.UserDefaults.hasSelectedLanguage)
    public static var hasSelectedLanguage: Bool?
    
    @UserDefault(StorageKeys.UserDefaults.hasSelectedRegion)
    public static var hasSelectedRegion: Bool?
    
    @UserDefault(StorageKeys.UserDefaults.hasViewedWalkthrough)
    public static var hasViewedWalkthrough: Bool?
    
    @UserDefault(StorageKeys.UserDefaults.hasShownInitialLoginOptions)
    public static var hasShownInitialLoginOptions: Bool?
    
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
