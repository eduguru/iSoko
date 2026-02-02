//
//  AuthInterceptor.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import Alamofire

public final class AuthInterceptor: RequestInterceptor {

    private let tokenProvider: RefreshableTokenProvider
    private var requiresAuth: Bool

    // Prevent multiple refreshes
    private var refreshTask: Task<TokenResponse?, Error>?

    public init(tokenProvider: RefreshableTokenProvider, requiresAuth: Bool = true) {
        self.tokenProvider = tokenProvider
        self.requiresAuth = requiresAuth
    }

    public func setRequiresAuth(_ requiresAuth: Bool) {
        self.requiresAuth = requiresAuth
    }

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        if requiresAuth, let token = tokenProvider.currentToken()?.accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {

        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        // If we already retried once, stop
        if request.retryCount > 0 {
            completion(.doNotRetry)
            return
        }

        // If a refresh is already in progress, wait for it
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

        // Start refresh only once
        refreshTask = Task {
            print("❗401 received — refreshing token...")
            let newToken = try await tokenProvider.refreshToken()
            if let token = newToken {
                tokenProvider.saveToken(token)
            }
            return newToken
        }

        Task {
            do {
                let token = try await refreshTask!.value
                refreshTask = nil

                if token != nil {
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            } catch {
                refreshTask = nil
                print("❌ Refresh failed:", error)
                completion(.doNotRetry)
            }
        }
    }
}
