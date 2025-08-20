//
//  AppConstants.swift
//  iSoko
//
//  Created by Edwin Weru on 20/08/2025.
//

final class AppConstants {
    static let shared = AppConstants()
    
    private init() {}
    
    enum GrantType: String {
        case login = "client_credentials"
        case token = "password"
        case refreshToken = "refresh_token"
    }
}
