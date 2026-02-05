//
//  RefreshableTokenProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import StorageKit

public protocol RefreshableTokenProvider {
    func currentOAuthToken() -> TokenResponse?
    func currentGuestToken() -> TokenResponse?
    func saveOAuthToken(_ token: TokenResponse)
    func saveGuestToken(_ token: TokenResponse)
    func refreshToken() async throws -> TokenResponse?
}
