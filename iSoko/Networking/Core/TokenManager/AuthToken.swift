//
//  AuthToken.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

public protocol AuthToken: Codable {
    var accessToken: String { get }
    var refreshToken: String? { get }
    var expiresIn: Int { get }
    
    var authTokenType: TokenType? { get set }

    func isValid() -> Bool
}

extension AuthToken {
    public func isValid() -> Bool {
        return true
    }
}
