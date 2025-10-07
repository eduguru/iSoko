//
//  OAuthService.swift
//  
//
//  Created by Edwin Weru on 06/10/2025.
//

import AuthenticationServices

final class OAuthService: NSObject {
    private var authSession: ASWebAuthenticationSession?

    func startOAuthFlow(completion: @escaping (Result<String, Error>) -> Void) {
        guard let authURL = OAuthConfig.authorizationURL else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }

        let callbackScheme = "weru.isoko.app" // Must match Info.plist

        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackScheme
        ) { callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let callbackURL = callbackURL else {
                completion(.failure(OAuthError.noCallbackURL))
                return
            }

            // Extract the code from the callback URL
            if let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                completion(.success(code))
            } else {
                completion(.failure(OAuthError.missingAuthorizationCode))
            }
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true
        authSession?.start()
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension OAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

// MARK: - Custom Error
enum OAuthError: Error {
    case invalidAuthURL
    case noCallbackURL
    case missingAuthorizationCode
}
