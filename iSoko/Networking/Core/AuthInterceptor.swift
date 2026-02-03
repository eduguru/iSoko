//
//  AuthInterceptor.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import Alamofire
import StorageKit

public final class AuthInterceptor: RequestInterceptor {

    private let tokenProvider: RefreshableTokenProvider
    private var requiresAuth: Bool

    // Prevent multiple refresh calls
    private var refreshTask: Task<TokenResponse?, Error>?

    public init(tokenProvider: RefreshableTokenProvider, requiresAuth: Bool = true) {
        self.tokenProvider = tokenProvider
        self.requiresAuth = requiresAuth
    }

    public func setRequiresAuth(_ requiresAuth: Bool) {
        self.requiresAuth = requiresAuth
    }

    // MARK: - Adapt
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        if requiresAuth, let token = tokenProvider.currentToken()?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // MARK: - Retry
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let response = request.response,
            response.statusCode == 401
        else {
            completion(.doNotRetry)
            return
        }

        // 🚫 Never retry more than once
        if request.retryCount > 0 {
            handleHardLogoutIfNeeded(response: response)
            completion(.doNotRetry)
            return
        }

        // If refresh already in progress → wait
        if let task = refreshTask {
            Task {
                do {
                    _ = try await task.value
                    completion(.retry)
                } catch {
                    completion(.doNotRetry)
                }
            }
            return
        }

        // Start refresh ONCE
        refreshTask = Task {
            print("🔁 401 received — refreshing token...")
            let token = try await tokenProvider.refreshToken()
            if let token {
                tokenProvider.saveToken(token)
            }
            return token
        }

        Task {
            do {
                let token = try await refreshTask!.value
                refreshTask = nil

                if token != nil {
                    completion(.retry)
                } else {
                    handleHardLogoutIfNeeded(response: response)
                    completion(.doNotRetry)
                }
            } catch {
                refreshTask = nil
                print("❌ Token refresh failed:", error)
                handleHardLogoutIfNeeded(response: response)
                completion(.doNotRetry)
            }
        }
    }

    // MARK: - Logout Logic
    private func handleHardLogoutIfNeeded(response: HTTPURLResponse) {
        let headers = response.allHeaderFields

        // Check WWW-Authenticate header
        if let authHeader = headers["WWW-Authenticate"] as? String {
            if authHeader.contains("invalid_token") ||
               authHeader.contains("expired") {
                print("🚪 Invalid token detected — logging out")
                forceLogout()
                return
            }
        }

        // Fallback: second 401 is always fatal
        print("🚪 Repeated 401 — logging out")
        forceLogout()
    }

    private func forceLogout() {
        refreshTask?.cancel()
        refreshTask = nil

        // Clear stored token
        AppStorage.authToken = nil
        AppStorage.hasLoggedIn = false

        // Optional: notify app
        NotificationCenter.default.post(
            name: .didLogoutDueToAuthFailure,
            object: nil
        )
    }
}

extension Notification.Name {
    static let didLogoutDueToAuthFailure =
        Notification.Name("didLogoutDueToAuthFailure")
}

//NotificationCenter.default.addObserver(
//    forName: .didLogoutDueToAuthFailure,
//    object: nil,
//    queue: .main
//) { _ in
//    // Navigate to login / reset app state
//}
