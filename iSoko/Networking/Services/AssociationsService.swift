//
//  AssociationsService.swift
//
//
//  Created by Edwin Weru on 03/02/2026.
//

import NetworkingKit

public protocol AssociationsService {
    //MARK: -
    func getAllAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    func getAllPendingAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    func getApprovedssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    
    func register(_ request: [String: Any], accessToken: String) async throws -> AssociationResponse?
    func update(associationId: Int, _ request: [String: Any], accessToken: String) async throws -> AssociationResponse?
    func review(associationId: Int, _ request: [String: Any], accessToken: String) async throws -> AssociationResponse?
    func getAssociationById(associationId: Int, accessToken: String) async throws -> AssociationResponse?

//MARK: - we get members here -
    func getAllAssociationMembers(associationId: Int, page: Int, count: Int, accessToken: String) async throws -> [AssociationMemberResponse]
    func addMember(associationId: Int, _ request: [String: Any], accessToken: String) async throws -> AssociationMemberResponse?
    func updateMember(memberId: Int, _ request: [String: Any], accessToken: String) async throws -> AssociationMemberResponse?
    func getAssociationMemberById(memberId: Int, accessToken: String) async throws -> AssociationMemberResponse?


 }

public final class AssociationsServiceImpl: AssociationsService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider

    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func getAllAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse] {
        let response = try await manager.request(AssociationsApi.getAllAssociations(page: page, count: count, accessToken: accessToken))
        return response.data
    }
    
    public func getAllPendingAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse] {
        let response = try await manager.request(AssociationsApi.getAllPendingAssociations(page: page, count: count, accessToken: accessToken))
        return response.data
    }
    
    public func getApprovedssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse] {
        let response = try await manager.request(AssociationsApi.getApprovedssociations(page: page, count: count, accessToken: accessToken))
        return response.data
    }
    
    public func register(_ request: [String : Any], accessToken: String) async throws -> AssociationResponse? {
        try await manager.request(AssociationsApi.register(request, accessToken: accessToken))
    }
    
    public func update(associationId: Int, _ request: [String : Any], accessToken: String) async throws -> AssociationResponse? {
        try await manager.request(AssociationsApi.update(associationId: associationId, request, accessToken: accessToken))
    }
    
    public func review(associationId: Int, _ request: [String : Any], accessToken: String) async throws -> AssociationResponse? {
        try await manager.request(AssociationsApi.review(associationId: associationId, request, accessToken: accessToken))
    }
    
    public func getAssociationById(associationId: Int, accessToken: String) async throws -> AssociationResponse? {
        try await manager.request(AssociationsApi.getAssociationById(associationId: associationId, accessToken: accessToken))
    }
    
    public func getAllAssociationMembers(associationId: Int, page: Int, count: Int, accessToken: String) async throws -> [AssociationMemberResponse] {
        let response = try await manager.request(AssociationsApi.getAllAssociationMembers(associationId: associationId, page: page, count: count, accessToken: accessToken))
        
        return response.data
    }
    
    public func addMember(associationId: Int, _ request: [String : Any], accessToken: String) async throws -> AssociationMemberResponse? {
        try await manager.request(AssociationsApi.addMember(associationId: associationId, request, accessToken: accessToken))
    }
    
    public func updateMember(memberId: Int, _ request: [String : Any], accessToken: String) async throws -> AssociationMemberResponse? {
        try await manager.request(AssociationsApi.updateMember(memberId: memberId, request, accessToken: accessToken))
    }
    
    public func getAssociationMemberById(memberId: Int, accessToken: String) async throws -> AssociationMemberResponse? {
        try await manager.request(AssociationsApi.getAssociationMemberById(memberId: memberId, accessToken: accessToken))
    }
}
