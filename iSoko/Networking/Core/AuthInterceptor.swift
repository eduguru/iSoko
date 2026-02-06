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

    private var refreshTask: Task<TokenResponse, Error>?
    
    public func setRequiresAuth(_ requiresAuth: Bool) {
        self.requiresAuth = requiresAuth
    }

    public init(
        tokenProvider: RefreshableTokenProvider,
        requiresAuth: Bool = true
    ) {
        self.tokenProvider = tokenProvider
        self.requiresAuth = requiresAuth
    }

    // MARK: - Adapt

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

//        let token = AppStorage.hasLoggedIn == true
//            ? tokenProvider.currentOAuthToken()
//            : tokenProvider.currentGuestToken()

//        if requiresAuth, let accessToken = token?.accessToken {
//            request.setValue(
//                "Bearer \(accessToken)",
//                forHTTPHeaderField: "Authorization"
//            )
//        }

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
            requiresAuth,
            AppStorage.hasLoggedIn == true,
            let response = request.response,
            response.statusCode == 401
        else {
            completion(.doNotRetry)
            return
        }

        if request.retryCount > 0 {
            forceLogout()
            completion(.doNotRetry)
            return
        }

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

        refreshTask = Task {
            try await tokenProvider.refreshOAuthToken()
        }

        Task {
            do {
                _ = try await refreshTask!.value
                refreshTask = nil
                completion(.retry)
            } catch {
                refreshTask = nil
                forceLogout()
                completion(.doNotRetry)
            }
        }
    }

    // MARK: - Logout

    private func forceLogout() {
        refreshTask?.cancel()
        refreshTask = nil

        // AppStorage.oauthToken = nil
        // AppStorage.hasLoggedIn = false

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
