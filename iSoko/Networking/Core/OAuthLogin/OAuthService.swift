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
import UtilsKit

extension OAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .keyWindow ?? ASPresentationAnchor()
    }
}

final class OAuthService: NSObject {

    private var session: ASWebAuthenticationSession?
    private var verifier = ""
    public var state = ""

    // MARK: - Authorization (Step 1)

    func startAuthorization(
        verifier: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.verifier = verifier
        self.state = UUID().uuidString

        let challenge = PKCE.codeChallenge(for: verifier)

        guard let authURL = OAuthConfig.authorizationURL(
            codeChallenge: challenge,
            state: state
        ) else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: OAuthConfig.callbackScheme
        ) { [weak self] callbackURL, error in
            guard let self else { return }

            if let error {
                completion(.failure(error))
                return
            }

            guard let url = callbackURL else {
                completion(.failure(OAuthError.missingAuthorizationCode))
                return
            }

            self.handleRedirect(url: url, completion: completion)
        }

        session?.presentationContextProvider = self
        session?.start()
    }

    // MARK: - Redirect handling

    private func handleRedirect(
        url: URL,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
            let returnedState = components.queryItems?.first(where: { $0.name == "state" })?.value,
            returnedState == state
        else {
            completion(.failure(OAuthError.invalidRedirect))
            return
        }

        completion(.success(code))
    }

    // MARK: - Token exchange (Step 2)

    func exchangeCodeForToken(
        authorizationCode: String,
        completion: @escaping (Result<TokenResponse, Error>) -> Void
    ) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: authorizationCode,
            codeVerifier: verifier,
            completion: completion
        )
    }

    // MARK: - User details (Step 3)

    func getUserDetails(
        accessToken: String,
        completion: @escaping (Result<UserDetails, Error>) -> Void
    ) {
        guard let url = URL(string: OAuthConfig.userInfoEndpoint) else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }

            // 🔍 DEBUG: Print raw JSON
            self.printJSON(data)

            do {
                let user = try JSONDecoder().decode(UserDetails.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func printJSON(_ data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]
            )

            if let jsonString = String(data: prettyData, encoding: .utf8) {
                print("📦 User Details JSON:\n\(jsonString)")
            }
        } catch {
            print("⚠️ Failed to print JSON:", error)
        }
    }

}
