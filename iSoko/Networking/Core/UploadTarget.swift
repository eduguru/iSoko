//
//  UploadTarget.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import Foundation
import Moya

public struct UploadTarget: TargetType {
    private let baseURLString: String
    private let pathValue: String
    private let methodValue: Moya.Method
    private let headersValue: [String: String]?
    private let multipartData: [MultipartFormData]

    public init(
        baseURL: String,
        path: String,
        method: Moya.Method = .post,
        headers: [String: String]? = nil,
        files: [UploadFile],
        additionalParams: [String: Any] = [:]
    ) {
        self.baseURLString = baseURL
        self.pathValue = path
        self.methodValue = method
        self.headersValue = headers

        var parts: [MultipartFormData] = []

        // 🔥 Attach multiple files
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

        // 🔥 Attach additional params
        for (key, value) in additionalParams {
            if let data = encodeParam(value) {
                parts.append(MultipartFormData(provider: .data(data), name: key))
            }
        }

        self.multipartData = parts
    }

    public var baseURL: URL { URL(string: baseURLString)! }
    public var path: String { pathValue }
    public var method: Moya.Method { methodValue }
    public var headers: [String: String]? { headersValue }
    public var sampleData: Data { Data() }
    public var task: Task { .uploadMultipart(multipartData) }
}

// 🔹 Parameter encoding helper
private func encodeParam(_ value: Any) -> Data? {
    switch value {
    case let string as String:
        return string.data(using: .utf8)
    case let int as Int:
        return "\(int)".data(using: .utf8)
    case let double as Double:
        return "\(double)".data(using: .utf8)
    case let bool as Bool:
        return (bool ? "true" : "false").data(using: .utf8)
    default:
        if JSONSerialization.isValidJSONObject(value),
           let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
            return data
        }
        return nil
    }
}
