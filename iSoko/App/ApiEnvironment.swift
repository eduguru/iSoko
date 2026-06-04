//
//  ApiEnvironment.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import Foundation
import StorageKit

public enum EnvironmentMode {
    case development
    case production
}

public enum ApiEnvironment {

    // MARK: - Environment

    #if DEBUG
    public static let mode: EnvironmentMode = .development
    #else
    public static let mode: EnvironmentMode = .production
    #endif

    // MARK: - Config Loading

    private static let config: ApiConfig = {

        guard let url = Bundle.main.url(
            forResource: "api_config",
            withExtension: "json"
        ) else {
            fatalError("api_config.json not found")
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ApiConfig.self, from: data)
        } catch {
            fatalError("Failed to decode api_config.json: \(error)")
        }
    }()

    // MARK: - Country

    private static var countryCode: String {
        (AppStorage.selectedRegionCode ?? "TZ")
            .uppercased()
    }

    private static var countryConfig: CountryConfig {
        guard let config = config.countries[countryCode] else {
            fatalError("No configuration found for country: \(countryCode)")
        }

        return config
    }

    // MARK: - Base URLs

    public static var apiBaseURL: URL {
        switch mode {
        case .development:
            return URL(string: "\(config.development.apiEndpoint)/v1/")!

        case .production:
            return URL(string: "\(countryConfig.apiEndpoint)/v1/")!
        }
    }

    /// Legacy BASE_URL
    public static var baseURL: URL {
        switch mode {
        case .development:
            return URL(string: "\(config.development.websiteUrl)/wit-backend/")!

        case .production:
            return URL(string: "\(countryConfig.websiteUrl)/wit-backend/")!
        }
    }

    public static var imageURL: URL {
        baseURL
    }

    public static var certificateBaseURL: URL {
        baseURL
    }

    public static var directUsBaseURL: URL {
        switch mode {
        case .development:
            return URL(string: config.development.directusUrl)!

        case .production:
            return URL(string: countryConfig.directusUrl)!
        }
    }

    // MARK: - Directus

    public static var directusUsername: String {
        switch mode {
        case .development:
            return config.development.directusUsername

        case .production:
            return countryConfig.directusUsername
        }
    }

    public static var directusPassword: String {
        switch mode {
        case .development:
            return config.development.directusPassword

        case .production:
            return countryConfig.directusPassword
        }
    }

    // MARK: - OAuth

    public static var grantType: String {
        config.development.grantType
    }

    public static var clientId: String {
        config.development.clientId
    }

    public static var clientSecret: String {
        config.development.clientSecret
    }

    // MARK: - Country Metadata

    public static var countryName: String? {
        guard mode == .production else { return nil }
        return countryConfig.countryName
    }

    public static var currency: String? {
        guard mode == .production else { return nil }
        return countryConfig.currency
    }
}
