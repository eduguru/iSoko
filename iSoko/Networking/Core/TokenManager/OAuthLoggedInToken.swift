//
//  .swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import Foundation

public struct OAuthLoggedInToken: AuthToken {
    public var refreshToken: String?
    public var authTokenType: TokenType? = .loggedIn
    public let accessToken: String
    public let expiresIn: Int
    
    init(refreshToken: String? = nil, authTokenType: TokenType? = nil, accessToken: String, expiresIn: Int) {
        self.refreshToken = refreshToken
        self.authTokenType = authTokenType
        self.accessToken = accessToken
        self.expiresIn = expiresIn
    }

    public func isValid() -> Bool { // Check expiration and validity for guest token
        return Date().timeIntervalSince1970 < Double(expiresIn)
    }
}
