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

    /// Generic request handler for any `TargetType`
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
                            continuation.resume(throwing: error) // Couldn't decode error response
                        }
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

// MARK: - Convenience API for AnyTarget-based calls
public extension NetworkManager where T == AnyTarget {
    
    // MARK: - Generic Envelope
    /// Handles API responses wrapped in `ResponseEnvelopeTarget`
    func request<R: Decodable>(_ envelope: ResponseEnvelopeTarget<R>) async throws -> R {
        return try await request(envelope.target)
    }

    // MARK: - Optional Object Envelope
    /// Handles responses wrapped in `OptionalObjectResponseTarget`
    func request<R: Decodable>(_ envelope: OptionalObjectResponseTarget<R>) async throws -> R? {
        let wrapper: OptionalObjectResponse<R> = try await request(envelope.target)
        return wrapper.data
    }

    // MARK: - Basic Response
    /// Handles responses returning a plain `BasicResponse`
    func request(_ envelope: BasicResponseTarget) async throws -> BasicResponse {
        return try await request(envelope.target)
    }

    // MARK: - Paged Response
    /// Handles paginated responses
    func request<R: Decodable>(_ envelope: PagedResponseTarget<R>) async throws -> PagedResponse<R> {
        return try await request(envelope.target)
    }

    // MARK: - Optional Paged Response
    /// Handles paginated responses where data may be optional
    func request<R: Decodable>(_ envelope: PagedOptionalResponseTarget<R>) async throws -> PagedOptionalResponse<R> {
        return try await request(envelope.target)
    }

    /// Convenience helper to directly access `.data` from a paginated optional response
    func requestData<R: Decodable>(_ envelope: PagedOptionalResponseTarget<R>) async throws -> R? {
        let wrapper: PagedOptionalResponse<R> = try await request(envelope.target)
        return wrapper.data
    }
}
