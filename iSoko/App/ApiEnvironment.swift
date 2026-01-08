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
        URL(string:
            "https://\(country).\(value("LEGACY_CORE_DOMAIN"))/\(value("LEGACY_CORE_PATH"))"
        )!
    }()

    // MARK: - V2 / API_BASE_URL

    public static var apiBaseURL: URL = {
        URL(string:
            "https://\(country).\(value("API_DOMAIN"))/\(value("API_PATH"))"
        )!
    }()

    // MARK: - Other URLs

    public static var imageURL: URL = {
        URL(string:
            "https://\(value("IMAGE_DOMAIN"))/\(value("LEGACY_CORE_PATH"))"
        )!
    }()

    public static var certificateBaseURL: URL = baseURL

    // MARK: - OAuth

    public static var clientId: String = value("CLIENT_ID")
    public static var clientSecret: String = value("CLIENT_SECRET")
}
