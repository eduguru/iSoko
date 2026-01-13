//
//  OAuthConfig.swift
//  
//
//  Created by Edwin Weru on 06/10/2025.
//

import Foundation
import CryptoKit


// MARK: - PKCE Helper
enum PKCE {

    static func generateCodeVerifier() -> String {
        let data = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        return base64URLEncode(data)
    }

    static func codeChallenge(for verifier: String) -> String {
        let data = Data(verifier.utf8)
        let hash = SHA256.hash(data: data)
        return base64URLEncode(Data(hash))
    }

    private static func base64URLEncode(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

// MARK: - OAuth Configuration
//struct OAuthConfig {
//
//    static let clientId = "Mobile"
//    static let responseType = "code"
//    static let scope = "openid"
//
//    // ✅ New HTTPS redirect
//    static let redirectURI = "https://api.dev.isoko.africa/v1/oauth2/authorized"
//
//    static let authorizationEndpoint = "https://api.dev.isoko.africa/v1/oauth2/authorize"
//    static let tokenEndpoint = "https://api.dev.isoko.africa/v1/oauth2/token"
//
//    // PKCE (per request)
//    static let state = UUID().uuidString
//    static let codeVerifier = PKCE.generateCodeVerifier()
//    static let codeChallenge = PKCE.codeChallenge(for: codeVerifier)
//    static let codeChallengeMethod = "S256"
//
//    static var authorizationURL: URL? {
//        var components = URLComponents(string: authorizationEndpoint)
//        components?.queryItems = [
//            .init(name: "response_type", value: responseType),
//            .init(name: "client_id", value: clientId),
//            .init(name: "scope", value: scope),
//            .init(name: "redirect_uri", value: redirectURI),
//            .init(name: "state", value: state),
//            .init(name: "code_challenge", value: codeChallenge),
//            .init(name: "code_challenge_method", value: codeChallengeMethod)
//        ]
//        return components?.url
//    }
//}

struct OAuthConfig {

    // MARK: - OAuth Client
    static let clientId = "Mobile"
    static let responseType = "code"
    static let scope = "openid"

    // MARK: - Redirect URI
    static var redirectURI: String {
        #if DEBUG
        return "weru.isoko.app://auth" // custom scheme for dev
        #else
        return "https://api.dev.isoko.africa/v1/oauth2/authorized" // HTTPS for prod
        #endif
    }

    // MARK: - Endpoints
    static let authorizationEndpoint = "https://api.dev.isoko.africa/v1/oauth2/authorize"
    static let tokenEndpoint = "https://api.dev.isoko.africa/v1/oauth2/token"

    // MARK: - PKCE (per request)
    static let state = UUID().uuidString
    static let codeVerifier = PKCE.generateCodeVerifier()
    static let codeChallenge = PKCE.codeChallenge(for: codeVerifier)
    static let codeChallengeMethod = "S256"

    // MARK: - Computed URL for authorization request
    static var authorizationURL: URL? {
        var components = URLComponents(string: authorizationEndpoint)
        components?.queryItems = [
            .init(name: "response_type", value: responseType),
            .init(name: "client_id", value: clientId),
            .init(name: "scope", value: scope),
            .init(name: "redirect_uri", value: redirectURI),
            .init(name: "state", value: state),
            .init(name: "code_challenge", value: codeChallenge),
            .init(name: "code_challenge_method", value: codeChallengeMethod)
        ]
        return components?.url
    }
}
