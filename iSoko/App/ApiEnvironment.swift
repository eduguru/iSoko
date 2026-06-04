//
//  ApiEnvironment.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import Foundation
import StorageKit

public enum ApiEnvironment {

    private static let info = Bundle.main.infoDictionary!

    // MARK: - Country

    private static var country: String {
        AppStorage.selectedRegionCode ?? (info["DEFAULT_COUNTRY_CODE"] as? String ?? "tz")
    }

    // MARK: - Helpers

    private static func value(_ key: String) -> String {
        guard let v = info[key] as? String else {
            fatalError("\(key) missing in Info.plist")
        }
        return v
    }

    // MARK: - V1 (BASE_URL)

    public static var baseURL: URL = {
        URL(string: "https://ke.isoko.africa/wit-backend/")!
    }()

    // MARK: - V2 / API_BASE_URL

    public static var apiBaseURL: URL = {
        URL(string: "https://api.dev.isoko.africa/v1/")!
    }()

    // MARK: - Other URLs

    public static var imageURL: URL = {
        URL(string: "https://isoko.twcc-tz.org/wit-backend/")!
    }()

    public static var certificateBaseURL: URL = baseURL
    
    public static var directUsBaseURL = URL(string: "https://directus.dev.isoko.africa")!

    // MARK: - OAuth

    public static var clientId: String = "wit_android_app"
    public static var clientSecret: String = "QBhd$Txm42n3q@"
}
