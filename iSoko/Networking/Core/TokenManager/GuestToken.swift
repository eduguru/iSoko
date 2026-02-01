//
//  GuestToken.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import Foundation


public struct GuestToken: AuthToken, Codable {
    public var refreshToken: String?
    public var authTokenType: TokenType? = .guest
    public let accessToken: String
    public let expiresIn: Int
    public var tokenType: String?
    public var scope: String?

    // Define CodingKeys for snake_case and mapping authTokenType
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
        case authTokenType
    }

    // Check expiration and validity
    public func isValid() -> Bool {
        Date().timeIntervalSince1970 < Double(expiresIn)
    }
}
