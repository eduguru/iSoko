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

// MARK: - OAuth Service
final class OAuthService: NSObject {

    private var authSession: ASWebAuthenticationSession?

    /// Step 1: Start authorization and get code
    func startAuthorization(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let authURL = OAuthConfig.authorizationURL else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        let callbackScheme: String? = {
            #if DEBUG
            return "weru.isoko.app" // custom scheme for dev
            #else
            return nil // universal link for prod
            #endif
        }()

        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackScheme) { callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let callbackURL = callbackURL,
                let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                let code = components.queryItems?.first(where: { $0.name == "code" })?.value
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

    /// Step 2: Exchange code for token
    func exchangeCodeForToken(
        authorizationCode: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        OAuthTokenService().exchangeAuthorizationCode(code: authorizationCode, completion: completion)
    }

    /// Step 3: Refresh token
    func refreshToken(
        refreshToken: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        OAuthTokenService().refreshToken(refreshToken: refreshToken, completion: completion)
    }

    /// Step 4: Convenience full flow
    func authorizeAndGetToken(
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        startAuthorization { [weak self] result in
            switch result {
            case .success(let code):
                self?.exchangeCodeForToken(authorizationCode: code, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Step 5: Auto-refresh token if expired
    func getValidToken(
        currentToken: OAuthTokenWithUserResponse?,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        guard let token = currentToken,
              let refresh_Token = token.refresh_token else {
            completion(.failure(OAuthError.missingRefreshToken))
            return
        }

        // Here you could check expiry timestamp if you store it
        refreshToken(refreshToken: refresh_Token, completion: completion)
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
// MARK: - OAuth Token Service
final class OAuthTokenService {

    func exchangeAuthorizationCode(
        code: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        requestToken(
            params: [
                "grant_type": "authorization_code",
                "client_id": OAuthConfig.clientId,
                "code": code,
                "redirect_uri": OAuthConfig.redirectURI,
                "code_verifier": OAuthConfig.codeVerifier,
                "scope": OAuthConfig.scope
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let bodyString = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
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

// MARK: - OAuth Errors
enum OAuthError: Error {
    case invalidAuthURL
    case missingAuthorizationCode
    case emptyResponse
    case missingRefreshToken
}


//USAGE EXAMPLE
//let oauth = OAuthService()
//oauth.authorizeAndGetToken { result in
//    switch result {
//    case .success(let token):
//        print("Access Token:", token.access_token)
//        print("Refresh Token:", token.refresh_token ?? "none")
//    case .failure(let error):
//        print("OAuth Error:", error)
//    }
//}
//
//service.exchangeAuthorizationCode(code: authCode) { result in
//    switch result {
//    case .success(let response):
//        print("Access token:", response.access_token)
//        print("User:", response.user ?? "No user")
//    case .failure(let error):
//        print("Error:", error)
//    }
//}
//
//// Full flow: authorize + get token
//oauthService.authorizeAndGetToken { result in
//    switch result {
//    case .success(let tokenResponse):
//        print("Access token:", tokenResponse.access_token)
//        print("Refresh token:", tokenResponse.refresh_token ?? "none")
//        print("User:", tokenResponse.user ?? "No user info")
//    case .failure(let error):
//        print("Error:", error)
//    }
//}
//
//// Refresh token
//if let refreshToken = tokenResponse.refresh_token {
//    oauthService.refreshToken(refreshToken: refreshToken) { result in
//        switch result {
//        case .success(let refreshed):
//            print("New access token:", refreshed.access_token)
//        case .failure(let error):
//            print("Refresh failed:", error)
//        }
//    }
//}
//
//// Suppose you have current token stored
//if let currentToken = savedToken {
//    oauthService.getValidToken(currentToken: currentToken) { result in
//        switch result {
//        case .success(let refreshedToken):
//            print("Refreshed access token:", refreshedToken.access_token)
//        case .failure(let error):
//            print("Failed to refresh token:", error)
//        }
//    }
//}
