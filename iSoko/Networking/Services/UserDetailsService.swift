//
//  UserDetailsService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Foundation
import NetworkingKit

public protocol UserDetailsService {
    
    //MARK: - get user details
    func getUserDetails(accessToken: String) async throws -> UserDetailsResponse?
    func getTraderVerificationDocuments(accessToken: String) async throws -> [TraderVerificationDocResponse]?

    //MARK: - update user details
    func updateUserDetails(accessToken: String, with dto: UserDetailsRequestDto) async throws -> BasicResponse
    func updateOrganisationDetails(accessToken: String, with dto: OrganisationDetailsRequestDto) async throws -> BasicResponse
    func updateUserEmail(email: String, accessToken: String) async throws -> BasicResponse
    func updateUserPhone(phone: String, accessToken: String) async throws -> BasicResponse
    func updateUserProfileImage(image: Data, accessToken: String) async throws -> BasicResponse
}

public class UserDetailsServiceImpl: UserDetailsService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func getUserDetails(accessToken: String) async throws -> UserDetailsResponse? {
        let response: UserDetailsResponse? = try await manager.request(
            UserDetailsApi.getUserDetails(accessToken: accessToken)
        )
        
        return response
    }
    
    public func getTraderVerificationDocuments(accessToken: String) async throws -> [TraderVerificationDocResponse]? {
        let response =  try await manager.request(
            UserDetailsApi.getTraderVerificationDocuments(accessToken: accessToken)
        )
        
        return response
    }
    
    public func updateUserDetails(accessToken: String, with dto: UserDetailsRequestDto) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            UserDetailsApi.updateUserDetails(accessToken: accessToken, with: dto)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func updateOrganisationDetails(accessToken: String, with dto: OrganisationDetailsRequestDto) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            UserDetailsApi.updateOrganisationDetails(accessToken: accessToken, with: dto)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func updateUserEmail(email: String, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            UserDetailsApi.updateUserEmail(email: email, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func updateUserPhone(phone: String, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            UserDetailsApi.updateUserPhone(phone: phone, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
    
    public func updateUserProfileImage(image: Data, accessToken: String) async throws -> BasicResponse {
        let response: BasicResponse = try await manager.request(
            UserDetailsApi.updateUserProfileImage(image: image, accessToken: accessToken)
        )
        
        if response.status != 200 {
            throw NetworkError.server(response)
        }
        
        return response
    }
}
