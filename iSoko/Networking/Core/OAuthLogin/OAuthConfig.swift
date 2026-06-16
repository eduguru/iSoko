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


// MARK: - OAuthConfig

struct OAuthConfig {

    static let clientId = "Mobile"
    static let scope    = "openid"

    // MARK: - Endpoints (derived from ApiEnvironment so country/env switching is automatic)

    static var userInfoEndpoint: String {
        ApiEnvironment.apiBaseURL.appendingPathComponent("oauth2/user-info").absoluteString
    }

    static var authorizationEndpoint: String {
        ApiEnvironment.apiBaseURL.appendingPathComponent("oauth2/authorize").absoluteString
    }

    static var tokenEndpoint: String {
        ApiEnvironment.apiBaseURL.appendingPathComponent("oauth2/token").absoluteString
    }

    static var loginEndpoint: String {
        ApiEnvironment.apiBaseURL.appendingPathComponent("oauth2/login").absoluteString
    }

    /// Primary redirect — universal link
    static var redirectURI: String {
        ApiEnvironment.apiBaseURL.appendingPathComponent("oauth2/authorized").absoluteString
    }

    /// Fallback redirect — custom scheme (unchanged, not region-specific)
    static let fallbackRedirectURI = "app://oauth2.isoko.authorized/callback"

    /// Custom scheme for AppDelegate / SceneDelegate to intercept the callback
    static let callbackScheme = "app"

    // MARK: - Authorization URL Builder

    static func authorizationURL(
        codeChallenge: String,
        state: String
    ) -> URL? {
        var components = URLComponents(string: authorizationEndpoint)
        components?.queryItems = [
            .init(name: "response_type",          value: "code"),
            .init(name: "client_id",              value: clientId),
            .init(name: "scope",                  value: scope),
            .init(name: "redirect_uri",           value: redirectURI),
            .init(name: "state",                  value: state),
            .init(name: "code_challenge",         value: codeChallenge),
            .init(name: "code_challenge_method",  value: "S256")
        ]
        return components?.url
    }
}
