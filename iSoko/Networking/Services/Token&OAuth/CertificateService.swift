//
//  CertificateService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Foundation
import NetworkingKit

public protocol CertificateService {
    func getToken(grant_type: String, client_id: String, client_secret: String) async throws -> GuestToken
    func getRefreshToken(grant_type: String, client_id: String, client_secret: String, refresh_token: String) async throws -> GuestToken
}


public final class CertificateServiceImpl: CertificateService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func getToken(grant_type: String, client_id: String, client_secret: String) async throws -> GuestToken {
        let response: GuestToken = try await manager.request(CertificateApi.getToken(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret)
        )
        
        let token = TokenResponse.init(
            accessToken: response.accessToken,
            tokenType: "",
            expiresIn: response.expiresIn,
            scope: "",
            refreshToken: response.refreshToken
        )
        
        tokenProvider.saveGuestToken(token)
        return response
    }
    
    public func getRefreshToken(grant_type: String, client_id: String, client_secret: String, refresh_token: String) async throws -> GuestToken {
        let response: GuestToken = try await manager.request(CertificateApi.getRefreshToken(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret, refresh_token: refresh_token)
        )
        
        let token = TokenResponse.init(
            accessToken: response.accessToken,
            tokenType: "",
            expiresIn: response.expiresIn,
            scope: "",
            refreshToken: response.refreshToken
        )
        
        tokenProvider.saveGuestToken(token)
        return response
    }
}
