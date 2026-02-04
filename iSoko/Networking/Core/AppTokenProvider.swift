//
//  AppTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 02/02/2026.
//

import Foundation
import StorageKit

public final class AppTokenProvider: RefreshableTokenProvider {

    private var refreshTask: Task<Void, Never>?

    public init() {}

    public func currentToken() -> TokenResponse? {
        AppStorage.authToken
    }

    public func saveToken(_ token: TokenResponse) {
        AppStorage.authToken = token

        // Cancel existing refresh task and reschedule
        refreshTask?.cancel()
        startRefreshTask(expiresIn: token.expiresIn)
    }

    public func refreshToken() async throws -> TokenResponse? {
        print("🔁 Attempting token refresh...")

        return try await withCheckedThrowingContinuation { continuation in
            if AppStorage.hasLoggedIn == true { // Logged-in user refresh
                let authToken = AppStorage.authToken
                OAuthTokenService().refreshToken(refreshToken: authToken?.refreshToken ?? "") { [weak self] resp in
                    switch resp {
                    case .success(let token):
                        self?.saveToken(token)
                        continuation.resume(returning: token)

                    case .failure(let error):
                        print("❌ Refresh token failed (logged-in):", error)
                        continuation.resume(throwing: error)
                    }
                }

            } else { // Guest refresh (async call inside a Task)
                Task {
                    do {
                        let response = try await GuestTokenService.getToken(
                            grant_type: "client_credentials",
                            client_id: ApiEnvironment.clientId,
                            client_secret: ApiEnvironment.clientSecret
                        )

                        let token = TokenResponse(
                            accessToken: response.accessToken,
                            tokenType: response.tokenType ?? "",
                            expiresIn: response.expiresIn,
                            scope: response.scope ?? "",
                            refreshToken: response.refreshToken ?? ""
                        )

                        self.saveToken(token)
                        continuation.resume(returning: token)

                    } catch {
                        print("❌ Refresh token failed (guest):", error)
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func startRefreshTask(expiresIn: Int) {
        refreshTask?.cancel()

        refreshTask = Task { [weak self] in
            guard let self = self else { return }

            while !Task.isCancelled {
                let refreshInterval = max(expiresIn - 60, 30)
                try? await Task.sleep(nanoseconds: UInt64(refreshInterval) * 1_000_000_000)

                if Task.isCancelled { break }

                do {
                    let token = try await self.refreshToken()
                    if let token = token {
                        self.saveToken(token)
                    }
                } catch {
                    print("❌ Token refresh failed:", error)
                    try? await Task.sleep(nanoseconds: 10 * 1_000_000_000)
                }
            }
        }
    }
}
