//
//  VendorToken.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import Foundation

struct VendorToken: AuthToken {
    var refreshToken: String?
    var authTokenType: TokenType? = .vendor
    let accessToken: String
    let expiresIn: Int

    func isValid() -> Bool { // Check expiration and validity for guest token
        return Date().timeIntervalSince1970 < Double(expiresIn)
    }
}
