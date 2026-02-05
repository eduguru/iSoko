//
//  AppTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 02/02/2026.
//

import Foundation
import StorageKit

public final class AppTokenProvider: RefreshableTokenProvider {

    private var oauthRefreshTask: Task<Void, Never>?

    public init() {}

    // MARK: - Current tokens

    public func currentOAuthToken() -> TokenResponse? {
        AppStorage.oauthToken
    }

    public func currentGuestToken() -> TokenResponse? {
        AppStorage.guestToken
    }

    // MARK: - Save tokens

    public func saveOAuthToken(_ token: TokenResponse) {
        AppStorage.oauthToken = token

        oauthRefreshTask?.cancel()
        startOAuthRefreshTask(expiresIn: token.expiresIn)
    }

    public func saveGuestToken(_ token: TokenResponse) {
        AppStorage.guestToken = token
        // ❗️No refresh scheduling for guest tokens
    }

    // MARK: - OAuth refresh ONLY

    public func refreshOAuthToken() async throws -> TokenResponse {
        guard let refreshToken = AppStorage.oauthToken?.refreshToken else {
            throw OAuthError.unauthorized(reason: "Missing refresh token")
        }

        return try await withCheckedThrowingContinuation { continuation in
            OAuthTokenService().refreshToken(refreshToken: refreshToken) { [weak self] result in
                switch result {
                case .success(let token):
                    self?.saveOAuthToken(token)
                    continuation.resume(returning: token)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Guest token fetch (NOT refresh)

    public func fetchGuestToken() async throws -> TokenResponse {
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
            refreshToken: "" // guests do NOT use refresh tokens
        )

        return token
    }

    // MARK: - OAuth auto refresh loop

    private func startOAuthRefreshTask(expiresIn: Int) {
        oauthRefreshTask?.cancel()

        oauthRefreshTask = Task { [weak self] in
            guard let self = self else { return }

            let refreshInterval = max(expiresIn - 60, 30)
            try? await Task.sleep(nanoseconds: UInt64(refreshInterval) * 1_000_000_000)

            if Task.isCancelled { return }

            do {
                _ = try await self.refreshOAuthToken()
            } catch {
                print("❌ OAuth auto-refresh failed:", error)
            }
        }
    }
}
