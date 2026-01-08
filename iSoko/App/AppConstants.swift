//
//  AppConstants.swift
//  iSoko
//
//  Created by Edwin Weru on 20/08/2025.
//

import Foundation
import StorageKit

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
        let selectedRegionCode = AppStorage.selectedRegionCode
        
        if selectedRegionCode == nil {
            let buildCountry = Bundle.main.object( forInfoDictionaryKey: "DEFAULT_COUNTRY_CODE" ) as? String ?? "tz"
            AppStorage.selectedRegionCode = buildCountry.lowercased()
        }
    }
}
