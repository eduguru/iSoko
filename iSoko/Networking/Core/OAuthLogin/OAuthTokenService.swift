//
//  OAuthTokenService.swift
//  
//
//  Created by Edwin Weru on 01/02/2026.
//

import Foundation
import CryptoKit
import AuthenticationServices
import UIKit
import UtilsKit

final class OAuthTokenService {

    func exchangeAuthorizationCode(
        code: String,
        codeVerifier: String,
        completion: @escaping (Result<TokenResponse, Error>) -> Void
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
        completion: @escaping (Result<TokenResponse, Error>) -> Void
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
        completion: @escaping (Result<TokenResponse, Error>) -> Void
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
                let token = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension OAuthService {
    func handleRedirect(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
              let returnedState = components.queryItems?.first(where: { $0.name == "state" })?.value,
              returnedState == state else {
            print("Invalid redirect URL or state mismatch")
            return
        }

        // Handle the authorization code and exchange it for tokens
        exchangeCodeForToken(authorizationCode: code) { result in
            switch result {
            case .success(let token):
                
                print("Access:", token)
                print("Access token:", token.accessToken)
                
            case .failure(let error):
                print("Error exchanging code for token:", error)
            }
        }
    }
}
