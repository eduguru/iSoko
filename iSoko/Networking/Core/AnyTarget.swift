//
//  AnyTarget.swift
//  NetworkingKit
//
//  Created by Edwin Weru on 19/08/2025.
//

import Moya
import Foundation

// MARK: - Convertible Protocol
public protocol ConvertibleToAnyTarget {
    func asAnyTarget() -> AnyTarget
}

// MARK: - AnyTarget
public struct AnyTarget: TargetType, AccessTokenAuthorizable {
    public let baseURL: URL
    public let path: String
    public let method: Moya.Method
    public let sampleData: Data
    public let task: Task
    public let validationType: ValidationType
    public let headers: [String: String]?
    public let authorizationType: AuthorizationType?

    public init(
        baseURL: URL = ApiEnvironment.baseURL,
        path: String = "",
        method: Moya.Method = .get,
        sampleData: Data = Data(),
        task: Task = .requestPlain,
        validationType: ValidationType = .successCodes,
        headers: [String: String]? = nil,
        authorizationType: AuthorizationType? = .bearer
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.sampleData = sampleData
        self.task = task
        self.validationType = validationType
        self.authorizationType = authorizationType
        self.headers = headers ?? AnyTarget.defaultHeaders(for: task)
    }

    public init(_ uploadTarget: UploadTarget) {
        self.init(
            baseURL: uploadTarget.baseURL,
            path: uploadTarget.path,
            method: uploadTarget.method,
            task: uploadTarget.task,
            headers: uploadTarget.headers,
            authorizationType: uploadTarget.authorizationType
        )
    }
}

private extension AnyTarget {
    static func defaultHeaders(for task: Task) -> [String: String] {
        switch task {
        case .requestParameters(_, let encoding):
            if encoding is URLEncoding {
                return ["Content-Type": "application/x-www-form-urlencoded"]
            } else if encoding is JSONEncoding {
                return ["Content-Type": "application/json"]
            }
            return [:]
        case .requestJSONEncodable, .requestCustomJSONEncodable:
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }
}
