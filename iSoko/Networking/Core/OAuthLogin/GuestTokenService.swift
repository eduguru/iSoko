//
//  GuestTokenService.swift
//  iSoko
//
//  Created by Edwin Weru on 02/02/2026.
//

import Foundation

public enum GuestTokenApiError: Error {
    case httpStatus(code: Int, message: String)
    case decoding(Error)
    case unknown
}

public struct GuestTokenService {

    private static var baseURL: URL {
        ApiEnvironment.baseURL
    }

    public static func getToken(
        grant_type: String,
        client_id: String,
        client_secret: String
    ) async throws -> GuestToken {

        let url = baseURL.appendingPathComponent("oauth/token")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let params = [
            "grant_type": grant_type,
            "client_id": client_id,
            "client_secret": client_secret
        ]

        let bodyString = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        // Retry logic
        let maxRetries = 2
        var attempt = 0

        while attempt <= maxRetries {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw GuestTokenApiError.unknown
                }

                // Handle HTTP errors
                guard (200...299).contains(httpResponse.statusCode) else {
                    let raw = String(data: data, encoding: .utf8) ?? "No body"

                    // If 401, you can log or handle differently
                    if httpResponse.statusCode == 401 {
                        print("❌ Guest token request returned 401")
                    }

                    throw GuestTokenApiError.httpStatus(code: httpResponse.statusCode, message: raw)
                }

                // Decode response
                do {
                    let token = try JSONDecoder().decode(GuestToken.self, from: data)
                    return token
                } catch {
                    throw GuestTokenApiError.decoding(error)
                }

            } catch {
                attempt += 1

                // If exceeded retries, rethrow
                if attempt > maxRetries {
                    throw error
                }

                // Exponential backoff
                let backoff = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
                try await Task.sleep(nanoseconds: backoff)

                print("🔁 Retrying guest token request (attempt \(attempt))")
            }
        }

        throw GuestTokenApiError.unknown
    }

    public static func getRefreshToken(
        grant_type: String,
        client_id: String,
        client_secret: String,
        refresh_token: String
    ) async throws -> GuestToken {
        return try await getToken(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret
        )
    }
}
