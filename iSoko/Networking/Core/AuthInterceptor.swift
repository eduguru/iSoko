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

    public init(tokenProvider: RefreshableTokenProvider) {
        self.tokenProvider = tokenProvider
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = tokenProvider.currentToken()?.accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        Task {
            do {
                let savedToken = try tokenProvider.currentToken()

                let newToken = try await tokenProvider.refreshToken(
                    grant_type: AppConstants.GrantType.refreshToken.rawValue,
                    client_id: ApiEnvironment.clientId,
                    client_secret: ApiEnvironment.clientSecret
                )
                tokenProvider.saveToken(newToken)
                completion(.retry)
            } catch {
                completion(.doNotRetry)
            }
        }
    }
}
