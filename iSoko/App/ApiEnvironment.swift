//
//  ApiEnvironment.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import Foundation

public enum ApiEnvironment {
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dictionary
    }()

    public static let baseURLString: String = {
        guard let baseURLString = ApiEnvironment.infoDictionary[Keys.baseURL.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return baseURLString
    }()
    
    public static let baseURL: URL = {
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Couldn't convert base url string to URL")
        }
        return baseURL
    }()
    
    public static let apiBaseURLString: String = {
        guard let baseURLString = ApiEnvironment.infoDictionary[Keys.apiBaseURL.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return baseURLString
    }()
    
    public static let apibBaseURL: URL = {
        guard let baseURL = URL(string: apiBaseURLString) else {
            fatalError("Couldn't convert base url string to URL")
        }
        return baseURL
    }()

    public static let certificateURLString: String = {
        guard let urlString = ApiEnvironment.infoDictionary[Keys.certificateBaseURL.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return urlString
    }()
    
    public static let certificateBaseURL: URL = {
        guard let baseURL = URL(string: certificateURLString) else {
            fatalError("Couldn't convert url string to URL")
        }
        return baseURL
    }()
    
    public static let imageURLString: String = {
        guard let urlString = ApiEnvironment.infoDictionary[Keys.imageURL.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return urlString
    }()

    public static let imageURL: URL = {
        guard let url = URL(string: imageURLString) else {
            fatalError("Couldn't convert url string to URL")
        }
        return url
    }()
    
    public static let clientSecret: String = {
        guard let urlString = ApiEnvironment.infoDictionary[Keys.client_secret.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return urlString
    }()
    
    public static let clientId: String = {
        guard let urlString = ApiEnvironment.infoDictionary[Keys.client_id.rawValue] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return urlString
    }()

    // MARK: -
    public static let appEnvironment: APPEnvironment = {
        let apiEnvironmentKey = ApiEnvironment.infoDictionary[Keys.environment.rawValue] as? String
        switch apiEnvironmentKey {
        case "Development":
            return .development

        case "UAT":
            return .uat

        case "Production":
            return .production

        default:
            return .development
        }
    }()
    
    // MARK: - Inner Declarations -
    public enum APPEnvironment: String {
        case development
        case uat
        case production
    }
    
    private enum Keys: String {
        case baseURL = "BASE_URL"
        case apiBaseURL = "API_BASE_URL"
        case certificateBaseURL = "CERTIFICATE_BASE_URL"
        case imageURL = "IMAGE_URL"
        case environment = "ENVIRONMENT"
        case client_id = "CLIENT_ID"
        case client_secret = "CLIENT_SECRET"
    }
}
