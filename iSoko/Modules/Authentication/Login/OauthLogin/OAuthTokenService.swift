//
//  OAuthTokenService.swift
//  
//
//  Created by Edwin Weru on 28/01/2026.
//

import Foundation

final class OAuthTokenService {

    func exchangeAuthorizationCode(
        code: String,
        codeVerifier: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        requestToken(
            params: [
                "grant_type": AppConstants.GrantType.authorizationCode.rawValue,
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
                "grant_type": AppConstants.GrantType.refreshToken.rawValue,
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
