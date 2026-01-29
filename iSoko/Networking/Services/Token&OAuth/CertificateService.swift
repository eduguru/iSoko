//
//  CertificateService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Foundation
import NetworkingKit

public protocol CertificateService {
    func getToken(grant_type: String, client_id: String, client_secret: String) async throws -> GuestTokenModel
    func getRefreshToken(grant_type: String, client_id: String, client_secret: String, refresh_token: String) async throws -> GuestTokenModel
}


public final class CertificateServiceImpl: CertificateService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func getToken(grant_type: String, client_id: String, client_secret: String) async throws -> GuestTokenModel {
        let token: GuestTokenModel = try await manager.request(GuestTokenApi.getToken(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret)
        )
        
        tokenProvider.saveToken(token)
        return token
    }
    
    public func getRefreshToken(grant_type: String, client_id: String, client_secret: String, refresh_token: String) async throws -> GuestTokenModel {
        let token: GuestTokenModel = try await manager.request(GuestTokenApi.getRefreshToken(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret, refresh_token: refresh_token)
        )
        
        tokenProvider.saveToken(token)
        return token
    }
}
