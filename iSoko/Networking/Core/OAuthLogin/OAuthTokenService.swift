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
import StorageKit

final class OAuthTokenService {

    // MARK: - Public API
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
                "refresh_token": refreshToken
            ],
            completion: completion
        )
    }

    // MARK: - Core Request

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
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        let bodyString = params
            .map { "\($0.key)=\($0.value.urlEncoded)" }
            .joined(separator: "&")

        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in

            // Transport error
            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                let data = data
            else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }

            // 🔴 401 — invalid / expired refresh token
            if httpResponse.statusCode == 401 {
                let authHeader = httpResponse
                    .allHeaderFields["WWW-Authenticate"] as? String

                print("🚫 OAuth 401 — invalid token")
                completion(
                    .failure(OAuthError.unauthorized(reason: authHeader))
                )
                return
            }

            // 🔴 Other HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                let raw = String(data: data, encoding: .utf8)
                completion(
                    .failure(
                        OAuthError.httpStatus(
                            code: httpResponse.statusCode,
                            message: raw
                        )
                    )
                )
                return
            }

            // ✅ Decode success
            do {
                let token = try JSONDecoder().decode(TokenResponse.self, from: data)
                AppStorage.hasLoggedIn = true
                AppStorage.oauthToken = token
                
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}
