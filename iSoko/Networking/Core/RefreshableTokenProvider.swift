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
