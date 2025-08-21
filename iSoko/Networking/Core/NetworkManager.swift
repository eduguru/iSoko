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

    init(tokenProvider: RefreshableTokenProvider, validateStatusCodes: Bool = false) {
        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)

        // Create Alamofire session
        let session: Session
        if validateStatusCodes {
            // ✅ Default Alamofire behavior → only 200..<300 is "success"
            session = Session(interceptor: interceptor)
        } else {
            // ❌ Skip validation so we always capture error bodies (400, 500, etc.)
            // 👉 If you want status code validation back, just remove this branch
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Session.default.sessionConfiguration.httpAdditionalHeaders

            // NOTE: `startRequestsImmediately` is true by default
            session = Session(
                configuration: configuration,
                interceptor: interceptor
            )
        }

        let logger = NetworkLoggerPlugin(level: NetworkConfig.logLevel)

        self.provider = MoyaProvider<T>(
            session: session,
            plugins: [logger],
            trackInflights: false
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
                    // ❌ Happens when status != 200–299 if validateStatusCodes = true
                    if let response = error.response {
                        do {
                            // Try decoding the server error into R (e.g. BasicResponse)
                            let decoded = try JSONDecoder().decode(R.self, from: response.data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error) // couldn't decode
                        }
                    } else {
                        continuation.resume(throwing: error)
                    }
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



//public final class NetworkManager<T: TargetType> {
//    private let provider: MoyaProvider<T>
//
//    init(tokenProvider: RefreshableTokenProvider) {
//        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)
//        let session = Session(interceptor: interceptor)
//
//        let logger = NetworkLoggerPlugin(level: NetworkConfig.logLevel)
//
//        self.provider = MoyaProvider<T>(
//            session: session,
//            plugins: [logger]
//        )
//    }
//
//    public func request<R: Decodable>(_ target: T) async throws -> R {
//        return try await withCheckedThrowingContinuation { continuation in
//            provider.request(target) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let decoded = try JSONDecoder().decode(R.self, from: response.data)
//                        continuation.resume(returning: decoded)
//                    } catch {
//                        continuation.resume(throwing: error)
//                    }
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//}
//
//public extension NetworkManager where T == AnyTarget {
//    func request<R: Decodable>(_ valueTarget: ValueResponseTarget<R>) async throws -> R {
//        return try await request(valueTarget.target)
//    }
//}
