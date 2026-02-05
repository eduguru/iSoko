//
//  GuestTokenService.swift
//  iSoko
//
//  Created by Edwin Weru on 02/02/2026.
//

import Foundation
import StorageKit

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

        request.httpBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        let maxRetries = 2
        var attempt = 0

        while true {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let http = response as? HTTPURLResponse else {
                    throw GuestTokenApiError.unknown
                }

                // 🔴 401 handling (NO retry)
                if http.statusCode == 401 {
                    let authHeader = http.allHeaderFields["WWW-Authenticate"] as? String
                    print("🚫 Guest token 401 — invalid credentials")

                    throw GuestTokenApiError.unauthorized(reason: authHeader)
                }

                // 🔴 Other non-2xx
                guard (200...299).contains(http.statusCode) else {
                    let raw = String(data: data, encoding: .utf8)
                    throw GuestTokenApiError.httpStatus(
                        code: http.statusCode,
                        message: raw ?? "No body"
                    )
                }

                // ✅ Decode success
                do {
                    let response = try JSONDecoder().decode(GuestToken.self, from: data)
                    
                    AppStorage.guestToken = .init(
                        accessToken: response.accessToken,
                        tokenType: response.tokenType ?? "",
                        expiresIn: response.expiresIn,
                        scope: response.scope ?? "",
                        refreshToken: response.refreshToken)
                    
                    return response
                } catch {
                    throw GuestTokenApiError.decoding(error)
                }

            } catch let error as GuestTokenApiError {
                // 🚫 Never retry auth failures
                if case .unauthorized = error {
                    throw error
                }

                attempt += 1
                if attempt > maxRetries {
                    throw error
                }

                await backoff(attempt)
                print("🔁 Retrying guest token (attempt \(attempt))")

            } catch {
                attempt += 1
                if attempt > maxRetries {
                    throw GuestTokenApiError.transport(error)
                }

                await backoff(attempt)
                print("🔁 Retrying guest token (attempt \(attempt))")
            }
        }
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

    private static func backoff(_ attempt: Int) async {
        let delay = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
        try? await Task.sleep(nanoseconds: delay)
    }
}
