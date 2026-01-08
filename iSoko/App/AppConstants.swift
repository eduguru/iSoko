//
//  AppConstants.swift
//  iSoko
//
//  Created by Edwin Weru on 20/08/2025.
//

import Foundation

final class AppConstants {
    static let shared = AppConstants()
    
    private init() {}
    
    enum GrantType: String {
        case login = "client_credentials"
        case token = "password"
        case refreshToken = "refresh_token"
    }
}


struct AppBootstrap {
    static func setup() {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "country_code") == nil {
            let buildCountry = Bundle.main.object( forInfoDictionaryKey: "DEFAULT_COUNTRY_CODE" ) as? String ?? "ke"
            defaults.set(buildCountry, forKey: "country_code")
        }
    }
}
