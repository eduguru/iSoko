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
    ) async throws -> TokenModel
    
    func preValidateEmail(_ email: String, accessToken: String) async throws -> BasicResponse
    func preValidatePhone(_ phone: String, accessToken: String) async throws -> BasicResponse
    
    // MARK: - Registration
    func register(_ request: RegistrationRequest, accessToken: String) async throws -> BasicResponse

}


public final class AuthenticationServiceImp: AuthenticationService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func login(grant_type: String, client_id: String, client_secret: String, username: String, password: String) async throws -> TokenModel {
        let token: TokenModel = try await manager.request(AuthenticationApi.login(
            grant_type: grant_type,
            client_id: client_id,
            client_secret: client_secret, username: username, password: password)
        )
        
        tokenProvider.saveToken(token)
        return token
    }
    
    // MARK: - Email Pre-validation
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
    
    public func accountVerificationOTP(type: RegistrationOTPType, contact: String, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.accountVerificationOTP(type: type, contact: contact, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    //MARK: - New Registration
    public func register(_ request: RegistrationRequest, accessToken: String) async throws -> BasicResponse {
        
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.register(request: request, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    //MARK: - Password Reset
    public func initiatePasswordReset(type: PasswordResetType, value: String, accessToken: String) async throws -> BasicResponse{
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.initiatePasswordReset(type: type, value: value, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }

    public func passwordReset(type: PasswordResetType, dto: PasswordResetDto, accessToken: String)  async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            AuthenticationApi.passwordReset(type: type, dto: dto, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
}

