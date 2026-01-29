//
//  GuestTokenModel.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import NetworkingKit

public struct GuestTokenModel: AuthToken, Codable {
    public let accessToken: String
    public let expiresIn: Int
    public let refreshToken: String?
    
    public let scope: String?
    public let tokenType: String?
    
    public var authTokenType: TokenType?
    
    /// When token expires (now + expiresIn seconds)
    var expiryDate: Date {
        Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case authTokenType
    }
}

