//
//  AuthenticationService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import NetworkingKit
import Combine
import Foundation
import UtilsKit

public protocol AuthenticationService {
    func login(
        grant_type: String,
        client_id: String,
        client_secret: String,
        username: String,
        password: String
    ) async throws -> TokenResponse
    
    func userLogout(accessToken: String) async throws -> AnyCodable
    
    func userAvailabilityCheck(parameters: [String: Any], accessToken: String)  async throws -> AnyCodable
    func preValidateEmail(_ email: String, accessToken: String) async throws -> BasicResponse
    func preValidatePhone(_ phone: String, accessToken: String) async throws -> BasicResponse
    
    // MARK: - Registration
    func registerUser(_ params: [String: Any], accessToken: String) async throws -> UserProfileResponse?
    
    // MARK: - Profile Update

    func updateUserProfile(
        id: Int,
        user: [String: Any]?,
        image: PickedFile?,
        accessToken: String
    ) async throws -> UserProfileResponse

    func updateProfileImageOnly(
        id: Int,
        image: PickedFile,
        accessToken: String
    ) async throws -> UserProfileResponse
    
    func passwordChange(id: Int, parameters: [String: Any], accessToken: String)  async throws -> AnyCodable
    func passwordResetInitiate(parameters: [String: Any], accessToken: String) async throws -> AnyCodable
    func passwordResetComplete(parameters: [String: Any], accessToken: String) async throws -> AnyCodable
    
    func deleteUserProfile(id: Int, parameters: [String: Any], accessToken: String) async throws -> AnyCodable

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
    
    // MARK: - Profile Update
    public func updateUserProfile(
        id: Int,
        user: [String: Any]?,
        image: PickedFile?,
        accessToken: String
    ) async throws -> UserProfileResponse {
        let response: UserProfileResponse = try await manager.request(
            AuthenticationApi.updateUserProfile(
                id: id,
                user: user,
                profileImage: image,
                accessToken: accessToken
            )
        )

        return response
    }
    
    public func updateProfileImageOnly(
        id: Int,
        image: PickedFile,
        accessToken: String
    ) async throws -> UserProfileResponse {
        let response: UserProfileResponse = try await manager.request(
            AuthenticationApi.updateProfileImageOnly(
                id: id,
                profileImage: image,
                accessToken: accessToken
            )
        )

        return response
    }
    
    //MARK: - Password Reset
    public func passwordChange(id: Int, parameters: [String: Any], accessToken: String)  async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.passwordChange(id: id, parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
    
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
    
    public func userLogout(accessToken: String) async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.userLogout(accessToken: accessToken)
        )
        
        return response
    }
    
    public func deleteUserProfile(id: Int, parameters: [String: Any], accessToken: String) async throws -> AnyCodable {
        let response: AnyCodable = try await manager.request(
            AuthenticationApi.deleteUserProfile(id: id, parameters: parameters, accessToken: accessToken)
        )
        
        return response
    }
}

