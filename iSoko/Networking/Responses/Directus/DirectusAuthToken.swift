//
//  DirectusAuthToken.swift
//  
//
//  Created by Edwin Weru on 29/04/2026.
//


struct DirectusAuthResponse: Decodable {
    let data: DirectusAuthToken
}

struct DirectusAuthToken: Decodable {
    let accessToken: String
    let refreshToken: String
    let expires: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
    }
}
