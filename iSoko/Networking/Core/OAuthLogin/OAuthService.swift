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
import WebKit

public final class OAuthService: NSObject {

    // MARK: - Properties
    private var session: ASWebAuthenticationSession?
    private var verifier = ""
    public var state = ""
    private var refreshTimer: Timer?

    public static let shared = OAuthService()
    let userDetailsService = NetworkEnvironment.shared.userDetailsService
    
    public var freshLoginEachTime: Bool = true

    // MARK: - Authorization (Step 1)
    // MARK: - Authorization (Step 1)
    public func startAuthorization(verifier: String) async throws -> String {
        self.verifier = verifier
        self.state = UUID().uuidString
        
        // Cancel previous session if a fresh login is requested
        if freshLoginEachTime {
            session?.cancel()
            session = nil
        }

        let challenge = PKCE.codeChallenge(for: verifier)
        guard let authURL = OAuthConfig.authorizationURL(codeChallenge: challenge, state: state) else {
            throw OAuthError.invalidAuthURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            // Create the ASWebAuthenticationSession
            self.session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: OAuthConfig.callbackScheme
            ) { [weak self] callbackURL, error in
                guard let self else { return }

                // Run everything on MainActor to ensure AppStorage/UI updates are safe
                Task { @MainActor in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let url = callbackURL,
                          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
                          let returnedState = components.queryItems?.first(where: { $0.name == "state" })?.value,
                          returnedState == self.state
                    else {
                        continuation.resume(throwing: OAuthError.invalidRedirect)
                        return
                    }

                    // Update session state immediately if desired
//                    AppStorage.hasLoggedIn = true
//                    RuntimeSession.authState = .authenticated

                    // Resume the async continuation
                    continuation.resume(returning: code)
                }
            }

            // Assign the presentation context provider
            self.session?.presentationContextProvider = self

            // Set ephemeral session if fresh login is requested (iOS 13+)
            if #available(iOS 13.0, *) {
                self.session?.prefersEphemeralWebBrowserSession = freshLoginEachTime
            }

            // Start the session
            self.session?.start()
        }
    }

    // MARK: - Token Exchange (Step 2)
    public func exchangeCodeForToken(authorizationCode: String) async throws -> TokenResponse {
        let tokenResponse = try await OAuthTokenService()
            .exchangeAuthorizationCodeAsync(code: authorizationCode, codeVerifier: verifier)

        saveToken(tokenResponse)
        return tokenResponse
    }

    // MARK: - Fetch User Details (Step 3)
    public func fetchUserAndUpdateStorage() async throws -> UserDetails {
        let accessToken = try await refreshTokenIfNeeded()
        let userDetails = try await getUserDetails(accessToken: accessToken)

        // Fetch full profile asynchronously in background
        Task(priority: .background) {
            await self.fetchFullUserProfileAsync(userId: userDetails.sub, accessToken: accessToken)
        }

        return userDetails
    }

    private func getUserDetails(accessToken: String) async throws -> UserDetails {
        guard let url = URL(string: OAuthConfig.userInfoEndpoint) else {
            throw OAuthError.invalidAuthURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let user = try JSONDecoder().decode(UserDetails.self, from: data)

        // Update AppStorage on main actor
        await MainActor.run {
            AppStorage.userDetail = user
            
//            AppStorage.hasLoggedIn = true
//            RuntimeSession.authState = .authenticated
            
            if AppStorage.oauthToken != nil {
                self.scheduleTokenRefresh()
            }
        }

        return user
    }

    // MARK: - Full User Profile Background Fetch
    private func fetchFullUserProfileAsync(userId: Int, accessToken: String) async {
        do {
            let fullProfile = try await userDetailsService.getUserProfile(id: userId, accessToken: accessToken)
            await MainActor.run {
                AppStorage.userProfile = fullProfile
                print("✅ Full profile fetched in background")
            }
        } catch {
            print("⚠️ Failed to fetch full profile:", error)
        }
    }

    // MARK: - Token Refresh
    public func refreshTokenIfNeeded() async throws -> String {
        guard let token = AppStorage.oauthToken else { throw OAuthError.missingRefreshToken }

        let now = Date()
        if token.expiryDate > now.addingTimeInterval(30) {
            scheduleTokenRefresh()
            return token.accessToken
        }

        guard let refreshToken = token.refreshToken else {
            throw OAuthError.missingRefreshToken
        }

        return try await refreshAccessToken(refreshToken: refreshToken)
    }

    private func refreshAccessToken(refreshToken: String) async throws -> String {
        var request = URLRequest(url: URL(string: OAuthConfig.tokenEndpoint)!)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": OAuthConfig.clientId
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        saveToken(tokenResponse)
        return tokenResponse.accessToken
    }

    // MARK: - Save Token & Schedule Refresh
    private func saveToken(_ token: TokenResponse) {
        AppStorage.oauthToken = token
        scheduleTokenRefresh()
    }

    private func scheduleTokenRefresh() {
        refreshTimer?.invalidate()

        guard let expiry = AppStorage.oauthToken?.expiryDate else { return }
        let interval = max(expiry.timeIntervalSinceNow - 60, 0)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                Task {
                    do {
                        guard let refreshToken = AppStorage.oauthToken?.refreshToken else { return }
                        _ = try await self.refreshAccessToken(refreshToken: refreshToken)
                        print("✅ Token automatically refreshed")
                    } catch {
                        print("⚠️ Token refresh failed:", error)
                    }
                }
            }
        }
    }
}

// MARK: - OAuthTokenService Async Wrapper
extension OAuthTokenService {
    func exchangeAuthorizationCodeAsync(code: String, codeVerifier: String) async throws -> TokenResponse {
        try await withCheckedThrowingContinuation { continuation in
            self.exchangeAuthorizationCode(code: code, codeVerifier: codeVerifier) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension OAuthService: ASWebAuthenticationPresentationContextProviding {

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {

        // Always resolve on MAIN THREAD (required for UIKit safety)
        if Thread.isMainThread {
            return resolveWindow()
        }

        var window: UIWindow?

        DispatchQueue.main.sync {
            window = resolveWindow()
        }

        return window ?? UIWindow()
    }

    // MARK: - UIKit-safe resolution (MUST be main thread)
    private func resolveWindow() -> UIWindow {

        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            ?? UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first
            ?? UIWindow()
        } else {
            return UIApplication.shared.keyWindow ?? UIWindow()
        }
    }
}

public extension OAuthService {
    func logout(clearCookies: Bool = true) {
        session?.cancel()
        session = nil

        AppStorage.oauthToken = nil
        AppStorage.userDetail = nil
        AppStorage.userProfile = nil
        AppStorage.hasLoggedIn = false
        RuntimeSession.authState = .guest

        refreshTimer?.invalidate()
        refreshTimer = nil

        if clearCookies {
            HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                cookies.forEach { WKWebsiteDataStore.default().httpCookieStore.delete($0) }
            }
        }

        print("✅ User logged out successfully")
    }
}

//extension OAuthService: ASWebAuthenticationPresentationContextProviding {
//    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
//        UIApplication.shared
//            .connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .first?
//            .keyWindow ?? ASPresentationAnchor()
//    }
//}

