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
    
    public init(tokenProvider: RefreshableTokenProvider) {
        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders =
            Session.default.sessionConfiguration.httpAdditionalHeaders

        let session = Session(
            configuration: configuration,
            interceptor: interceptor
        )

        let logger = NetworkLoggerPlugin(level: NetworkConfig.logLevel)
        self.provider = MoyaProvider(
            session: session,
            plugins: [logger],
            trackInflights: false
        )
    }


    // A method to request and handle any target
    public func request<R: Decodable>(_ target: T) async throws -> R {
        // Update the interceptor to reflect the correct requiresAuth flag
        if let anyTarget = target as? AnyTarget {
            let interceptor = provider.session.interceptor as! AuthInterceptor
            interceptor.setRequiresAuth(anyTarget.requiresAuth)
        }

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        // Try decoding normally
                        let decoded = try JSONDecoder().decode(R.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        // Decoding failed, print raw response for debugging
                        if let rawString = String(data: response.data, encoding: .utf8) {
                            print("⚠️ Decoding failed. Raw response:\n\(rawString)")
                        } else {
                            print("⚠️ Decoding failed. Raw bytes: \(response.data as NSData)")
                        }
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    // Failure handling for non-2xx status (401, 403, etc.)
                    if let response = error.response {
                        if let rawString = String(data: response.data, encoding: .utf8) {
                            print("⚠️ Request failed. Status: \(response.statusCode), Raw response:\n\(rawString)")
                        } else {
                            print("⚠️ Request failed. Status: \(response.statusCode), Raw bytes: \(response.data as NSData)")
                        }

                        // Try decoding anyway even if status != 200
                        do {
                            let decoded = try JSONDecoder().decode(R.self, from: response.data)
                            continuation.resume(returning: decoded)
                            return // exit early if successful
                        } catch {
                            print("⚠️ Decoding failed for non-200 response")
                        }
                    }

                    // Pass the original error if nothing works
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


// MARK: - Convenience API for AnyTarget
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

    func request<R: Decodable>(_ envelope: UnifiedPagedResponseTarget<R>) async throws -> UnifiedPagedEnvelope<R> {
        return try await request(envelope.target)
    }
}

// MARK: - Upload Support
public extension NetworkManager where T == UploadTarget {

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
            additionalParams: additionalParams
        )
        return try await request(target)
    }

    func request<R: Decodable>(_ envelope: ResponseEnvelopeTarget<R, UploadTarget>) async throws -> R {
        return try await request(envelope.target)
    }
}


// Initializer now accepts tokenProvider and allows validation of status codes
//    public init(tokenProvider: RefreshableTokenProvider, validateStatusCodes: Bool = false) {
//        let interceptor = AuthInterceptor(tokenProvider: tokenProvider)
//
//        // Configure Alamofire session with the given interceptor
//        let session: Session
//        if validateStatusCodes {
//            // Validate status codes if true
//            session = Session(interceptor: interceptor)
//        } else {
//            // Disable automatic status code validation (for custom 401/403 handling)
//            let configuration = URLSessionConfiguration.default
//            configuration.httpAdditionalHeaders = Session.default.sessionConfiguration.httpAdditionalHeaders
//            session = Session(configuration: configuration, interceptor: interceptor)
//        }
//
//        let logger = NetworkLoggerPlugin(level: NetworkConfig.logLevel)
//        self.provider = MoyaProvider<T>(session: session, plugins: [logger], trackInflights: false)
//    }
