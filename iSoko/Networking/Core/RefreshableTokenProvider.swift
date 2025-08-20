//
//  RefreshableTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import StorageKit


//public protocol RefreshableTokenProvider {
//    associatedtype Token: AuthToken
//
//    func currentToken() -> Token?
//    func saveToken(_ token: Token)
//    func refreshToken(
//        grant_type: String,
//        client_id: String,
//        client_secret: String
//    ) async throws -> Token
//}


public protocol RefreshableTokenProvider {
    func currentToken() -> TokenModel?
    func saveToken(_ token: TokenModel)
    func refreshToken(grant_type: String, client_id: String, client_secret: String) async throws -> TokenModel
}

public final class AppTokenProvider: RefreshableTokenProvider {
    private var refreshTask: Task<Void, Never>?

    public init() {}

    // MARK: - Current Token
    public func currentToken() -> TokenModel? {
        return AppStorage.authToken
    }

    // MARK: - Save Token & Start Refresh Task
    public func saveToken(_ token: TokenModel) {
        AppStorage.authToken = token
        AppStorage.accessToken = token.accessToken
        AppStorage.refreshToken = token.refreshToken
        AppStorage.tokenExpiry = Date().addingTimeInterval(TimeInterval(token.expiresIn))

        // Cancel any existing refresh task
        refreshTask?.cancel()

        // Schedule new auto-refresh
        startRefreshTask(expiresIn: token.expiresIn)
    }

    // MARK: - Refresh Token
    public func refreshToken(
        grant_type: String,
        client_id: String,
        client_secret: String
    ) async throws -> TokenModel {
        guard let refresh = AppStorage.refreshToken else {
            throw NSError(domain: "AppTokenProvider", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "No refresh token available"])
        }

        let token: TokenModel = try await NetworkProvider(tokenProvider: self)
            .manager()
            .request(
                CertificateApi.getRefreshToken(
                    grant_type: grant_type,
                    client_id: client_id,
                    client_secret: client_secret,
                    refresh_token: refresh
                ).target
            )

        saveToken(token) // reschedules refresh
        return token
    }

    // MARK: - Private
    private func startRefreshTask(expiresIn: Int) {
        let fireInterval = max(TimeInterval(expiresIn - 60), 30)
        print("⏰ Scheduling refresh in \(fireInterval) seconds")

        refreshTask = Task.detached { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(fireInterval * 1_000_000_000))
            guard let self else { return }
            do {
                let newToken = try await self.refreshToken(
                    grant_type: AppConstants.GrantType.refreshToken.rawValue,
                    client_id: ApiEnvironment.clientId,
                    client_secret: ApiEnvironment.clientSecret
                )
                print("✅ Auto refreshed token: \(newToken.accessToken)")
            } catch {
                print("❌ Failed to auto-refresh token: \(error)")
            }
        }
    }
}
