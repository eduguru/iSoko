//
//  AuthenticationService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import NetworkingKit
import Combine
import Foundation

public protocol AuthenticationService {
    func login(
        grant_type: String,
        client_id: String,
        client_secret: String,
        username: String,
        password: String
    ) async throws -> TokenResponse
    
    func userAvailabilityCheck(parameters: [String: Any], accessToken: String)  async throws -> AnyCodable
    func preValidateEmail(_ email: String, accessToken: String) async throws -> BasicResponse
    func preValidatePhone(_ phone: String, accessToken: String) async throws -> BasicResponse
    
    // MARK: - Registration
    func registerUser(_ params: [String: Any], accessToken: String) async throws -> UserProfileResponse?
    
    func passwordResetInitiate(parameters: [String: Any], accessToken: String) async throws -> AnyCodable
    func passwordResetComplete(parameters: [String: Any], accessToken: String)  async throws -> AnyCodable

}


public final class AuthenticationServiceImp: AuthenticationService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func login(grant_type: String, client_id: String, client_secret: String, username: String, password: String) async throws -> TokenResponse {
        let token: TokenResponse = try await manager.request(AuthenticationApi.login(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret, username: username, password: password)
        )
        
        return token
    }
    
    // MARK: - Pre-validation
    public func userAvailabilityCheck(parameters: [String: Any], accessToken: String)  async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.userAvailabilityCheck(parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
    
    public func preValidateEmail(_ email: String, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.preValidateEmail(email: email, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func preValidatePhone(_ phone: String, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.preValidatePhoneNumber(phoneNumber: phone, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func accountVerificationOTP(parameters: [String: Any], accessToken: String) async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.accountVerificationOTP(parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
    
    public func verifyAccountOTP(parameters: [String: Any], accessToken: String) async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.verifyAccountOTP(parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
    
    //MARK: - New Registration
    public func registerUser(_ params: [String: Any], accessToken: String) async throws -> UserProfileResponse? {
        let response: UserProfileResponse = try await manager.request(
            AuthenticationApi.registerUser(params, accessToken: accessToken)
        )
        
        return response
    }
    
    //MARK: - Password Reset
    public func passwordResetInitiate(parameters: [String: Any], accessToken: String) async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.passwordResetInitiate(parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }

    public func passwordResetComplete(parameters: [String: Any], accessToken: String)  async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.passwordResetComplete(parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
    
}

