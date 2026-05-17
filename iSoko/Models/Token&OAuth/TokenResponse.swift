//
//  TokenResponse.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation

public struct TokenResponse: Codable {
    
    // MARK: - Properties

    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int
    public let scope: String?
    public let refreshToken: String?
    
    /// Actual expiry date computed from `expiresIn`
    public let expiryDate: Date

    // MARK: - Initializer

    /// Initialize manually or from decoded JSON
    public init(
        accessToken: String,
        tokenType: String,
        expiresIn: Int,
        scope: String? = nil,
        refreshToken: String? = nil,
        expiryDate: Date? = nil
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.scope = scope
        self.refreshToken = refreshToken
        self.expiryDate = expiryDate ?? Date().addingTimeInterval(TimeInterval(expiresIn))
    }

    // MARK: - Coding Keys for JSON decoding

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType   = "token_type"
        case expiresIn   = "expires_in"
        case scope
        case refreshToken = "refresh_token"
    }
}

// MARK: - Convenience Computed Properties

extension TokenResponse {
    
    /// Returns true if token is expired
    public var isExpired: Bool {
        Date() >= expiryDate
    }
    
    /// Returns true if token should be refreshed soon (e.g., 60s before expiry)
    public var shouldRefresh: Bool {
        Date() >= expiryDate.addingTimeInterval(-60)
    }
}

// MARK: - Optional: JSON Decoding with Automatic expiryDate

extension TokenResponse {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let accessToken = try container.decode(String.self, forKey: .accessToken)
        let tokenType   = try container.decode(String.self, forKey: .tokenType)
        let expiresIn   = try container.decode(Int.self, forKey: .expiresIn)
        let scope       = try container.decodeIfPresent(String.self, forKey: .scope)
        let refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        
        self.init(
            accessToken: accessToken,
            tokenType: tokenType,
            expiresIn: expiresIn,
            scope: scope,
            refreshToken: refreshToken
        )
    }
}
