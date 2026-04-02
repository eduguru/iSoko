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
        print("🧩 AuthInterceptor.adapt called → \(urlRequest.url?.absoluteString ?? "")")
        completion(.success(urlRequest))
    }


    // MARK: - Retry

    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        // Only care about HTTP responses
        guard
            let response = request.response,
            response.statusCode == 401
        else {
            completion(.doNotRetry)
            return
        }

        print("🛑 401 detected in AuthInterceptor")

        // 🔹 If this request does NOT require auth → never retry, never logout
        guard requiresAuth else {
            print("ℹ️ 401 on non-auth request → ignoring")
            completion(.doNotRetry)
            return
        }

        // 🔹 Auth request, but app believes user is NOT logged in
        // This is a state mismatch, not a logout case
        guard AppStorage.hasLoggedIn == true else {
            print("401 on auth request but user already logged out → normalize state")
            RuntimeSession.authState = .guest
            completion(.doNotRetry)
            return
        }

        // 🔹 Already retried once → refresh failed → force logout
        if request.retryCount > 0 {
            print("🚪 Refresh already attempted → forcing logout")
            forceLogout()
            completion(.doNotRetry)
            return
        }

        // 🔹 If a refresh is already in progress, wait for it
        if let task = refreshTask {
            Task {
                do {
                    _ = try await task.value
                    completion(.retry)
                } catch {
                    print("❌ Shared refresh failed → logout")
                    forceLogout()
                    completion(.doNotRetry)
                }
            }
            return
        }

        // 🔹 Start refresh
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
                print("❌ Token refresh failed → logout")
                forceLogout()
                completion(.doNotRetry)
            }
        }
    }



//    public func retry(
//        _ request: Request,
//        for session: Session,
//        dueTo error: Error,
//        completion: @escaping (RetryResult) -> Void
//    ) {
//        guard
//            requiresAuth,
//            AppStorage.hasLoggedIn == true,
//            let response = request.response,
//            response.statusCode == 401
//        else {
//            completion(.doNotRetry)
//            return
//        }
//
//        if request.retryCount > 0 {
//            forceLogout()
//            completion(.doNotRetry)
//            return
//        }
//
//        if let task = refreshTask {
//            Task {
//                do {
//                    _ = try await task.value
//                    completion(.retry)
//                } catch {
//                    completion(.doNotRetry)
//                }
//            }
//            return
//        }
//
//        refreshTask = Task {
//            try await tokenProvider.refreshOAuthToken()
//        }
//
//        Task {
//            do {
//                _ = try await refreshTask!.value
//                refreshTask = nil
//                completion(.retry)
//            } catch {
//                refreshTask = nil
//                forceLogout()
//                completion(.doNotRetry)
//            }
//        }
//    }

    // MARK: - Logout
    private func forceLogout() {
        print("🚪 Forcing logout (AuthInterceptor)")

        refreshTask?.cancel()
        refreshTask = nil

        RuntimeSession.authState = .guest
        AppStorage.hasLoggedIn = false

        NotificationCenter.default.post(
            name: .authTokenExpired,
            object: nil
        )
    }


}
