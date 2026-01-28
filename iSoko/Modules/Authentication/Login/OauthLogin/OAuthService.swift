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

final class OAuthService: NSObject {

    private var session: ASWebAuthenticationSession?
    private var verifier = ""
    private var state = ""

    func startAuthorization(completion: @escaping (Result<String, Error>) -> Void) {
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

    func handleRedirect(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
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

    func exchangeCodeForToken(authorizationCode: String, completion: @escaping (Result<OAuthTokenWithUserResponse, Error>) -> Void) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: authorizationCode,
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
