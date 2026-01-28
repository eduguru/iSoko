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

    private var session: ASWebAuthenticationSession?
    private var verifier = ""
    private var state = ""

    func startAuthorization(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        verifier = PKCE.generateCodeVerifier()
        let challenge = PKCE.codeChallenge(for: verifier)
        state = UUID().uuidString

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

    func exchangeCodeForToken(
        code: String,
        completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void
    ) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: code,
            codeVerifier: verifier,
            completion: completion
        )
    }
    
    
    func handleOAuthFailure(error: Error) {
        let alertController = UIAlertController(
            title: "Authentication Failed",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.startAuthorization { result in
                // Handle retry success or failure here
            }
        }))
        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alertController, animated: true)
    }

    
    func exchangeCodeForToken(authorizationCode: String, completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: authorizationCode,
            codeVerifier: verifier,
            completion: completion
        )
    }
}

extension OAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .keyWindow ?? ASPresentationAnchor()
    }
}

extension UIWindowScene {
    var keyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}

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
                print("Access token:", token.access_token)
                
            case .failure(let error):
                print("Error exchanging code for token:", error)
            }
        }
    }
}



public extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
