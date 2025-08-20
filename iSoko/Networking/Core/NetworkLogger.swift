//
//  NetworkLogger.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import Moya


public final class NetworkLoggerPlugin: PluginType {
    private let level: NetworkLogLevel

    public init(level: NetworkLogLevel) {
        self.level = level
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        guard level != .none else { return }

        if let request = request.request {
            print("📤 [REQUEST]")
            print("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

            if level == .verbose {
                if let headers = request.allHTTPHeaderFields {
                    print("📝 Headers: \(headers)")
                }
                if let body = request.httpBody,
                   let bodyString = String(data: body, encoding: .utf8) {
                    print("📦 Body: \(bodyString)")
                }
            }
            print("-------------------------------")
        }
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard level != .none else { return }

        print("📥 [RESPONSE]")

        switch result {
        case .success(let response):
            print("⬅️ Status: \(response.statusCode)")
            print("🌐 URL: \(response.response?.url?.absoluteString ?? "")")

            if level == .verbose {
                if let headers = response.response?.allHeaderFields {
                    print("📝 Headers: \(headers)")
                }
                if let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: .mutableContainers),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("📦 Body: \(prettyString)")
                } else if let rawString = String(data: response.data, encoding: .utf8) {
                    print("📦 Body: \(rawString)")
                }
            }

        case .failure(let error):
            print("❌ Error: \(error.localizedDescription)")
        }

        print("===============================")
    }
}
