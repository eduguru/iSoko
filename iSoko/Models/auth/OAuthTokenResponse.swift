//
//  OAuthTokenResponse.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import Foundation

// MARK: - OAuth Token Models
struct OAuthTokenResponse: Decodable {
    let access_token: String
    let refresh_token: String?
    let expires_in: Int
    let token_type: String
}

struct OAuthTokenWithUserResponse: Decodable {
    let access_token: String
    let refresh_token: String?
    let expires_in: Int
    let token_type: String
    let user: UserV1Response?
}
