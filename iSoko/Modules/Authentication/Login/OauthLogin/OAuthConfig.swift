//
//  OAuthConfig.swift
//  
//
//  Created by Edwin Weru on 06/10/2025.
//

import Foundation

struct OAuthConfig {
    static let clientId = "Mobile"
    static let redirectURI = "weru.isoko.app://auth" // ← Your app's custom scheme
    static let authorizationEndpoint = "https://api.kristalogic.com/v1/oauth2/authorize"
    static let tokenEndpoint = "https://api.kristalogic.com/v1/oauth2/token"
    static let responseType = "code"
    static let scope = "openid"
    
    // Optional: Add state + PKCE if supported
    static let state = "esadsqw"
    static let codeChallenge = "n4bQgYhMfWWaL-qgxVrQFaO_TxsrC4Is0V1sFbDwCgg"
    static let codeChallengeMethod = "S256"
    
    static var authorizationURL: URL? {
        var components = URLComponents(string: authorizationEndpoint)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod)
        ]
        return components?.url
    }
}
