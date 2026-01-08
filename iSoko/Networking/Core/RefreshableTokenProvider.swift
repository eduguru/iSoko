//
//  RefreshableTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import StorageKit

public protocol RefreshableTokenProvider {
    func currentToken() -> TokenModel?
    func saveToken(_ token: TokenModel)
    func refreshToken(
        grant_type: String,
        client_id: String,
        client_secret: String
    ) async throws -> TokenModel
}

public final class AppTokenProvider: RefreshableTokenProvider {
    private var refreshTask: Task<Void, Never>?

    public init() {}

    // MARK: - Current Token
    public func currentToken() -> TokenModel? {
        AppStorage.authToken
    }

    // MARK: - Save Token & Start Refresh Task
    public func saveToken(_ token: TokenModel) {
        AppStorage.authToken = token
        AppStorage.accessToken = token.accessToken
        AppStorage.refreshToken = token.refreshToken
        AppStorage.tokenExpiry = Date().addingTimeInterval(TimeInterval(token.expiresIn))

        // Cancel existing refresh task and reschedule
        refreshTask?.cancel()
        // startRefreshTask(expiresIn: token.expiresIn)
        startRefreshTask(expiresIn: 20)
    }

    // MARK: - Refresh Token
    public func refreshToken(
        grant_type: String,
        client_id: String,
        client_secret: String
    ) async throws -> TokenModel {
        guard let refresh = AppStorage.refreshToken else {
            throw NSError(
                domain: "AppTokenProvider",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No refresh token available"]
            )
        }

        // ✅ No `.target` needed now
        let token: TokenModel = try await NetworkProvider(tokenProvider: self)
            .manager()
            .request(
                CertificateApi.getRefreshToken(
                    grant_type: grant_type,
                    client_id: client_id,
                    client_secret: client_secret,
                    refresh_token: refresh
                )
            )

        saveToken(token)
        return token
    }

    // MARK: - Private
    private func startRefreshTask(expiresIn: Int) {
        // Cancel any previous task
        refreshTask?.cancel()
        
        // Start a new task that keeps running until cancelled (i.e., app exit)
        refreshTask = Task { [weak self] in
            guard let self = self else { return }
            
            while !Task.isCancelled {
                // Refresh a bit before token expires (e.g., 60 seconds before)
                let refreshInterval = max(expiresIn - 60, 30) // at least 30s delay
                try? await Task.sleep(nanoseconds: UInt64(refreshInterval) * 1_000_000_000)
                
                // Exit if cancelled
                if Task.isCancelled { break }
                
                do {
                    // Attempt to refresh using stored client_id/secret
                    let _ = try await self.refreshToken(
                        grant_type: "refresh_token",
                        client_id: ApiEnvironment.clientId,
                        client_secret: ApiEnvironment.clientSecret
                    )
                    // Successfully refreshed, loop continues
                } catch {
                    // Handle refresh error
                    print("Failed to refresh token: \(error)")
                    // Optional: retry after a short delay
                    try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10s
                }
            }
        }
    }

}
