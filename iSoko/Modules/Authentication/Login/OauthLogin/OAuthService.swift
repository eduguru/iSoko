//
//  OAuthService.swift
//  
//
//  Created by Edwin Weru on 06/10/2025.
//

import Foundation
import CryptoKit
import AuthenticationServices
import UIKit

final class OAuthService: NSObject {

    private var authSession: ASWebAuthenticationSession?

    // PKCE state for this authorization request
    private var codeVerifier: String = ""
    private var state: String = ""

    func startAuthorization(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // Generate PKCE for this request
        codeVerifier = PKCE.generateCodeVerifier()
        let codeChallenge = PKCE.codeChallenge(for: codeVerifier)
        state = UUID().uuidString

        guard let authURL = OAuthConfig.authorizationURL(
            codeChallenge: codeChallenge,
            state: state
        ) else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: nil
        ) { [weak self] callbackURL, error in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let url = callbackURL,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
                let returnedState = components.queryItems?.first(where: { $0.name == "state" })?.value,
                returnedState == self.state
            else {
                completion(.failure(OAuthError.missingAuthorizationCode))
                return
            }

            completion(.success(code))
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true
        authSession?.start()
    }

    func exchangeCodeForToken(
        authorizationCode: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: authorizationCode,
            codeVerifier: codeVerifier,
            completion: completion
        )
    }
}

// MARK: - Presentation Context
extension OAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) }
            .first ?? ASPresentationAnchor()
    }
}


import Foundation

final class OAuthTokenService {

    func exchangeAuthorizationCode(
        code: String,
        codeVerifier: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        requestToken(
            params: [
                "grant_type": "authorization_code",
                "client_id": OAuthConfig.clientId,
                "code": code,
                "redirect_uri": OAuthConfig.redirectURI,
                "code_verifier": codeVerifier
            ],
            completion: completion
        )
    }

    func refreshToken(
        refreshToken: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        requestToken(
            params: [
                "grant_type": "refresh_token",
                "client_id": OAuthConfig.clientId,
                "refresh_token": refreshToken,
                "scope": OAuthConfig.scope
            ],
            completion: completion
        )
    }

    private func requestToken(
        params: [String: String],
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        guard let url = URL(string: OAuthConfig.tokenEndpoint) else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = params
            .map { "\($0.key)=\($0.value.urlEncoded)" }
            .joined(separator: "&")

        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }

            do {
                let token = try JSONDecoder().decode(OAuthTokenWithUserResponse.self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

private extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
