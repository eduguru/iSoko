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

    // Default is true for authorization, but can be adjusted per request
    public init(tokenProvider: RefreshableTokenProvider, requiresAuth: Bool = true) {
        self.tokenProvider = tokenProvider
        self.requiresAuth = requiresAuth
    }

    // Method to dynamically set the requiresAuth flag
    public func setRequiresAuth(_ requiresAuth: Bool) {
        self.requiresAuth = requiresAuth
    }

    // Intercepts the request and adds the Authorization header if needed
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if requiresAuth, let token = tokenProvider.currentToken()?.accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // Retry the request in case of a 401 (Unauthorized) error, attempting to refresh the token
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
//        Task {
//            do {
//                let savedToken = try tokenProvider.currentToken()
//                let newToken = try await tokenProvider.refreshToken()
//                if let token = newToken {
//                    tokenProvider.saveToken(token)
//                }
//                
//                completion(.retry)
//            } catch {
//                completion(.doNotRetry)
//            }
//        }
    }
}
