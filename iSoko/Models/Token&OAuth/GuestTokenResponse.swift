//
//  GuestTokenResponse.swift
//
//
//  Created by Edwin Weru on 14/01/2026.
//

import Foundation

// MARK: - OAuth Token Models
public struct GuestTokenResponse: Codable {
    public let accessToken: String
    public let refreshToken: String?
    public let expiresIn: Int
    public let tokenType: String?
 
    /// When token expires (now + expiresIn seconds)
    var expiryDate: Date {
        Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}

