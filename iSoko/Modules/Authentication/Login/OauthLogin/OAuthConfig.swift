//
//  OAuthConfig.swift
//  
//
//  Created by Edwin Weru on 06/10/2025.
//

import Foundation
import CryptoKit

enum PKCE {

    static func generateCodeVerifier() -> String {
        let data = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        return base64URLEncode(data)
    }

    static func codeChallenge(for verifier: String) -> String {
        let hash = SHA256.hash(data: Data(verifier.utf8))
        return base64URLEncode(Data(hash))
    }

    private static func base64URLEncode(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}


struct OAuthConfig {

    static let clientId = "Mobile"
    static let scope = "openid"

    static let authorizationEndpoint =
        "https://api.dev.isoko.africa/v1/oauth2/authorize"

    static let tokenEndpoint =
        "https://api.dev.isoko.africa/v1/oauth2/token"

    // Primary (Universal Link)
    static let redirectURI =
        "https://api.dev.isoko.africa/v1/oauth2/authorized"

    // Fallback (Custom Scheme)
    static let fallbackRedirectURI =
        "app://oauth2.isoko.authorized/callback"

    // SCHEME ONLY
    static let callbackScheme = "app"

    static func authorizationURL(
        codeChallenge: String,
        state: String
    ) -> URL? {

        var components = URLComponents(string: authorizationEndpoint)
        components?.queryItems = [
            .init(name: "response_type", value: "code"),
            .init(name: "client_id", value: clientId),
            .init(name: "scope", value: scope),

            // Server should prefer universal link
            .init(name: "redirect_uri", value: redirectURI),

            .init(name: "state", value: state),
            .init(name: "code_challenge", value: codeChallenge),
            .init(name: "code_challenge_method", value: "S256")
        ]
        return components?.url
    }
}


enum OAuthError: Error {
    case invalidAuthURL
    case missingAuthorizationCode
    case emptyResponse
    case missingRefreshToken
    case invalidRedirect
}
