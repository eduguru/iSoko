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
    
    /// Timer for automatic token refresh
    private var refreshTimer: Timer?

    // MARK: - Shared Instance (optional singleton)
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
            completion(.failure(OAuthError.invalidRedirect))
            return
        }
        completion(.success(code))
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
                completion(.success(tokenResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - User Details (Step 3)
    /// Fetch user details using access token (refreshes if needed)
    public func fetchUserAndUpdateStorage(completion: @escaping (Result<UserDetails, Error>) -> Void) {
        refreshTokenIfNeeded { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let accessToken):
                self.getUserDetails(accessToken: accessToken, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getUserDetails(
        accessToken: String,
        completion: @escaping (Result<UserDetails, Error>) -> Void
    ) {
        guard let url = URL(string: OAuthConfig.userInfoEndpoint) else {
            completion(.failure(OAuthError.invalidAuthURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(UserDetails.self, from: data)
                
                DispatchQueue.main.async {
                    // ✅ Update user profile and logged-in state
                    AppStorage.userProfile = user
                    AppStorage.hasLoggedIn = true
                    RuntimeSession.authState = .authenticated
                    
                    // Ensure token refresh timer is scheduled
                    if let token = AppStorage.oauthToken {
                        self.scheduleTokenRefresh()
                    }
                }
                
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Token Refresh
    public func refreshTokenIfNeeded(completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = AppStorage.oauthToken else {
            completion(.failure(OAuthError.missingRefreshToken))
            return
        }
        
        let now = Date()
        if token.expiryDate > now.addingTimeInterval(30) {
            // Token still valid
            scheduleTokenRefresh() // ✅ Ensure timer is active
            completion(.success(token.accessToken))
            return
        }
        
        // Token expired, refresh
        guard let refreshToken = token.refreshToken else {
            completion(.failure(OAuthError.missingRefreshToken))
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
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.saveToken(tokenResponse)
                }
                
                completion(.success(tokenResponse.accessToken))
            } catch {
                completion(.failure(error))
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
        let interval = max(expiry.timeIntervalSinceNow - 60, 0) // Refresh 1 min before expiry
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                guard let refreshToken = AppStorage.oauthToken?.refreshToken else { return }
                self.refreshAccessToken(refreshToken: refreshToken) { result in
                    switch result {
                    case .success:
                        print("🔁 Token automatically refreshed")
                    case .failure(let error):
                        print("⚠️ Token refresh failed:", error)
                        // Optionally, reset logged-in state
                        DispatchQueue.main.async {
                            AppStorage.hasLoggedIn = false
                            RuntimeSession.authState = .guest
                        }
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
    /// Restore token refresh timer on app launch
    public func restoreTokenStateIfNeeded() {
        if AppStorage.hasLoggedIn ?? false, let _ = AppStorage.oauthToken {
            scheduleTokenRefresh()
        }
    }
}
