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
import StorageKit

public final class OAuthService: NSObject {

    // MARK: - Properties
    private var session: ASWebAuthenticationSession?
    private var verifier = ""
    public var state = ""
    
    private var refreshTimer: Timer?

    // MARK: - Shared Instance
    public static let shared = OAuthService()

    // MARK: - Authorization (Step 1)
    public func startAuthorization(
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
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let url = callbackURL else {
                DispatchQueue.main.async { completion(.failure(OAuthError.missingAuthorizationCode)) }
                return
            }
            
            self.handleRedirect(url: url, completion: completion)
        }
        
        session?.presentationContextProvider = self
        session?.start()
    }

    // MARK: - Redirect Handling
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
            DispatchQueue.main.async { completion(.failure(OAuthError.invalidRedirect)) }
            return
        }
        DispatchQueue.main.async { completion(.success(code)) }
    }

    // MARK: - Token Exchange (Step 2)
    public func exchangeCodeForToken(
        authorizationCode: String,
        completion: @escaping (Result<TokenResponse, Error>) -> Void
    ) {
        OAuthTokenService().exchangeAuthorizationCode(
            code: authorizationCode,
            codeVerifier: verifier
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let tokenResponse):
                self.saveToken(tokenResponse)
                DispatchQueue.main.async { completion(.success(tokenResponse)) }
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    // MARK: - User Details (Step 3)
    public func fetchUserAndUpdateStorage(completion: @escaping (Result<UserDetails, Error>) -> Void) {
        refreshTokenIfNeeded { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let accessToken):
                self.getUserDetails(accessToken: accessToken, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    public func getUserDetails(
        accessToken: String,
        completion: @escaping (Result<UserDetails, Error>) -> Void
    ) {
        guard let url = URL(string: OAuthConfig.userInfoEndpoint) else {
            DispatchQueue.main.async { completion(.failure(OAuthError.invalidAuthURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async { completion(.failure(OAuthError.emptyResponse)) }
                return
            }
            
            do {
                let user = try JSONDecoder().decode(UserDetails.self, from: data)
                
                // Update AppStorage safely on main thread
                DispatchQueue.main.async {
                    AppStorage.userProfile = user
                    AppStorage.hasLoggedIn = true
                    RuntimeSession.authState = .authenticated
                    
                    if let _ = AppStorage.oauthToken {
                        self.scheduleTokenRefresh()
                    }
                    
                    completion(.success(user))
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    // MARK: - Token Refresh
    public func refreshTokenIfNeeded(completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = AppStorage.oauthToken else {
            DispatchQueue.main.async { completion(.failure(OAuthError.missingRefreshToken)) }
            return
        }
        
        let now = Date()
        if token.expiryDate > now.addingTimeInterval(30) {
            scheduleTokenRefresh()
            DispatchQueue.main.async { completion(.success(token.accessToken)) }
            return
        }
        
        guard let refreshToken = token.refreshToken else {
            DispatchQueue.main.async { completion(.failure(OAuthError.missingRefreshToken)) }
            return
        }
        
        refreshAccessToken(refreshToken: refreshToken, completion: completion)
    }
    
    private func refreshAccessToken(
        refreshToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        var request = URLRequest(url: URL(string: OAuthConfig.tokenEndpoint)!)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": OAuthConfig.clientId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async { completion(.failure(OAuthError.emptyResponse)) }
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.saveToken(tokenResponse)
                    completion(.success(tokenResponse.accessToken))
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    // MARK: - Save Token & Schedule Refresh
    private func saveToken(_ token: TokenResponse) {
        AppStorage.oauthToken = token
        scheduleTokenRefresh()
    }

    // MARK: - Automatic Token Refresh
    private func scheduleTokenRefresh() {
        refreshTimer?.invalidate()
        
        guard let expiry = AppStorage.oauthToken?.expiryDate else { return }
        let interval = max(expiry.timeIntervalSinceNow - 60, 0)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                guard let refreshToken = AppStorage.oauthToken?.refreshToken else { return }
                
                self.refreshAccessToken(refreshToken: refreshToken) { result in
                    switch result {
                    case .success:
                        print(" Token automatically refreshed")
                    case .failure(let error):
                        print("⚠️ Token refresh failed:", error)
                        // Do NOT reset logged-in state automatically
                        // Optional: Notify user or app of auth error
                    }
                }
            }
        }
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension OAuthService: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .keyWindow ?? ASPresentationAnchor()
    }
}

// MARK: - Optional Helper for App Launch
extension OAuthService {
    public func restoreTokenStateIfNeeded() {
        if AppStorage.hasLoggedIn ?? false, let _ = AppStorage.oauthToken {
            scheduleTokenRefresh()
        }
    }
}
