//
//  RefreshableTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import StorageKit

public protocol RefreshableTokenProvider {
    func currentToken() -> TokenResponse?
    func saveToken(_ token: TokenResponse)
    func refreshToken() async throws -> TokenResponse?
}

public final class AppTokenProvider: RefreshableTokenProvider {
    // private var refreshTask: Task<Void, Never>?
    
    public init() {
        
    }

    // MARK: - Current Token
    public func currentToken() -> TokenResponse? {
        AppStorage.authToken
    }

    // MARK: - Save Token & Start Refresh Task
    public func saveToken(_ token: TokenResponse) {
        AppStorage.authToken = token
        // Cancel existing refresh task and reschedule
        // refreshTask?.cancel()
        // startRefreshTask(expiresIn: token.expiresIn)
        // startRefreshTask(expiresIn: 30)
    }
    
    // MARK: - Refresh Token
    public func refreshToken() async -> TokenResponse? {
        print("perform refresh token here")
        return nil
    }
    
    // MARK: - Private
//    private func startRefreshTask(expiresIn: Int) {
//        // Cancel any previous task
//        refreshTask?.cancel()
//        
//        // Start a new task that keeps running until cancelled (i.e., app exit)
//        refreshTask = Task { [weak self] in
//            guard let self = self else { return }
//            
//            while !Task.isCancelled {
//                // Refresh a bit before token expires (e.g., 60 seconds before)
//                let refreshInterval = max(expiresIn - 60, 30) // at least 30s delay
//                try? await Task.sleep(nanoseconds: UInt64(refreshInterval) * 1_000_000_000)
//                
//                // Exit if cancelled
//                if Task.isCancelled { break }
//                
//                do {
//                    // Attempt to refresh using stored client_id/secret
//                    let _ = try await self.refreshToken() // Successfully refreshed, loop continues
//                } catch {
//                    // Handle refresh error
//                    print("Failed to refresh token: \(error)")
//                    // Optional: retry after a short delay
//                    try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10s
//                }
//            }
//        }
//    }

}
