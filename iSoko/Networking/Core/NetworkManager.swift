//
//  NetworkManager.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//
import Foundation
import Moya
import Alamofire
import NetworkingKit

// MARK: - Network Manager
public final class NetworkManager<T: TargetType> {
    private let provider: MoyaProvider<T>

    public init(tokenProvider: RefreshableTokenProvider, validateStatusCodes: Bool = false) {
        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)

        // Configure Alamofire session
        let session: Session
        if validateStatusCodes {
            session = Session(interceptor: interceptor)
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Session.default.sessionConfiguration.httpAdditionalHeaders
            session = Session(configuration: configuration, interceptor: interceptor)
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
                    if let response = error.response {
                        do {
                            let decoded = try JSONDecoder().decode(R.self, from: response.data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

// MARK: - Convenience API for AnyTarget (Standard JSON Calls)
public extension NetworkManager where T == AnyTarget {

    func request<R: Decodable>(_ envelope: ResponseEnvelopeTarget<R, AnyTarget>) async throws -> R {
        return try await request(envelope.target)
    }

    func request<R: Decodable>(_ envelope: OptionalObjectResponseTarget<R>) async throws -> R? {
        let wrapper: OptionalObjectResponse<R> = try await request(envelope.target)
        return wrapper.data
    }

    func request(_ envelope: BasicResponseTarget) async throws -> BasicResponse {
        return try await request(envelope.target)
    }

    func request<R: Decodable>(_ envelope: PagedResponseTarget<R>) async throws -> PagedResponse<R> {
        return try await request(envelope.target)
    }

    func request<R: Decodable>(_ envelope: PagedOptionalResponseTarget<R>) async throws -> PagedOptionalResponse<R> {
        return try await request(envelope.target)
    }

    func requestData<R: Decodable>(_ envelope: PagedOptionalResponseTarget<R>) async throws -> R? {
        let wrapper: PagedOptionalResponse<R> = try await request(envelope.target)
        return wrapper.data
    }
}

// MARK: - Upload Support (UploadTarget)
public extension NetworkManager where T == UploadTarget {

    /// Upload a single file
    func upload<R: Decodable>(
        baseURL: URL,
        path: String,
        method: Moya.Method = .post,
        headers: [String: String]? = nil,
        file: UploadFile,
        additionalParams: [String: Any] = [:]
    ) async throws -> R {
        return try await uploadFiles(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            files: [file],
            additionalParams: additionalParams
        )
    }

    /// Upload multiple files
    func uploadFiles<R: Decodable>(
        baseURL: URL,
        path: String,
        method: Moya.Method = .post,
        headers: [String: String]? = nil,
        files: [UploadFile],
        additionalParams: [String: Any] = [:]
    ) async throws -> R {
        let target = UploadTarget(
            baseURL: baseURL,
            path: path,
            method: method,
            files: files,
            additionalParams: additionalParams,
            headers: headers
        )
        return try await request(target)
    }

    /// Unified upload request using an envelope target
    func request<R: Decodable>(_ envelope: ResponseEnvelopeTarget<R, UploadTarget>) async throws -> R {
        return try await request(envelope.target)
    }
}
