//
//  NetworkManager.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import Moya

public final class NetworkManager<T: TargetType> {
    private let provider: MoyaProvider<T>

    init(tokenProvider: RefreshableTokenProvider) {
        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)
        let session = Session(interceptor: interceptor)

        let logger = NetworkLoggerPlugin(level: NetworkConfig.logLevel)

        self.provider = MoyaProvider<T>(
            session: session,
            plugins: [logger]
        )
    }

    public func request<R: Decodable>(_ target: T) async throws -> R {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(R.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public extension NetworkManager where T == AnyTarget {
    func request<R: Decodable>(_ valueTarget: ValueResponseTarget<R>) async throws -> R {
        return try await request(valueTarget.target)
    }
}
