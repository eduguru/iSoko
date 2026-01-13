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

    func startAuthorization(
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        guard let authURL = OAuthConfig.authorizationURL else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        // Universal Link scheme is HTTPS
        let callbackScheme = "https"

//        authSession = ASWebAuthenticationSession(
//            url: authURL,
//            callbackURLScheme: callbackScheme
//        )
        
        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "weru.isoko.app"
        )
        { callbackURL, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let callbackURL = callbackURL,
                let components = URLComponents(
                    url: callbackURL,
                    resolvingAgainstBaseURL: false
                ),
                let code = components.queryItems?
                    .first(where: { $0.name == "code" })?.value
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

// MARK: - OAuth Token Exchange
struct OAuthTokenResponse: Decodable {
    let access_token: String
    let refresh_token: String?
    let expires_in: Int
    let token_type: String
}

final class OAuthTokenService {

    func exchangeCodeForToken(
        authorizationCode: String,
        completion: @escaping (Result<OAuthTokenResponse, Error>) -> Void
    ) {

        var request = URLRequest(url: URL(string: OAuthConfig.tokenEndpoint)!)
        request.httpMethod = "POST"
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        let bodyParams: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": OAuthConfig.clientId,
            "code": authorizationCode,
            "redirect_uri": OAuthConfig.redirectURI,
            "code_verifier": OAuthConfig.codeVerifier
        ]

        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)

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
                let token = try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
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
}
