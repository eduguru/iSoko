//
//  TokenModel.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import NetworkingKit

public struct TokenModel: AuthToken {
    public let accessToken: String
    public let expiresIn: Int
    public let refreshToken: String?
    
    public let scope: String?
    public let tokenType: String?
    
    /// When token expires (now + expiresIn seconds)
    var expiryDate: Date {
        Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    public init(accessToken: String, tokenType: String, expiresIn: Int, scope: String, refreshToken: String?) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.scope = scope
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}

