//
//  UploadTarget.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import Foundation
import Moya

// MARK: - UploadTarget
public struct UploadTarget: TargetType, ConvertibleToAnyTarget {
    public let baseURL: URL
    public let path: String
    public let method: Moya.Method
    public let headers: [String: String]?
    public let authorizationType: AuthorizationType?
    public let multipartData: [MultipartFormData]

    public init(
        baseURL: URL = ApiEnvironment.baseURL,
        path: String,
        method: Moya.Method = .post,
        files: [UploadFile],
        additionalParams: [String: Any] = [:],
        headers: [String: String]? = nil,
        authorizationType: AuthorizationType? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.authorizationType = authorizationType

        var parts: [MultipartFormData] = []

        for file in files {
            parts.append(
                MultipartFormData(
                    provider: .data(file.data),
                    name: file.name,
                    fileName: file.fileName,
                    mimeType: file.mimeType
                )
            )
        }

        for (key, value) in additionalParams {
            if let data = UploadTarget.encodeParam(value) {
                parts.append(MultipartFormData(provider: .data(data), name: key))
            }
        }

        self.multipartData = parts
    }

    public var task: Task {
        return .uploadMultipart(multipartData)
    }

    public func asAnyTarget() -> AnyTarget {
        return AnyTarget(self)
    }

    private static func encodeParam(_ value: Any) -> Data? {
        switch value {
        case let string as String: return string.data(using: .utf8)
        case let int as Int: return "\(int)".data(using: .utf8)
        case let double as Double: return "\(double)".data(using: .utf8)
        case let bool as Bool: return (bool ? "true" : "false").data(using: .utf8)
        default:
            if JSONSerialization.isValidJSONObject(value),
               let data = try? JSONSerialization.data(withJSONObject: value) {
                return data
            }
            return nil
        }
    }
}
