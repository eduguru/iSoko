//
//  AssociationsService.swift
//
//
//  Created by Edwin Weru on 03/02/2026.
//

import NetworkingKit
import UtilsKit

public protocol AssociationsService {
    //MARK: -
    func getAllAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    func getAllPendingAssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    func getApprovedssociations(page: Int, count: Int, accessToken: String) async throws -> [AssociationResponse]
    
    func enrollIntoAssociation(associationId: Int, accessToken: String) async throws -> AssociationMemberResponse?
    func cancelMembership(memberId: Int, comment: String, accessToken: String) async throws -> AssociationMemberResponse?
    
    func getAssociationProducts(id: Int, page: Int, count: Int, accessToken: String) async throws -> PagedResult<[ProductResponseV1]>
    
    func register(
        association: [String: Any],
        logo: PickedFile?,
        certificate: PickedFile?,
        accessToken: String
    ) async throws -> AssociationResponse?
    
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
    
    public func register(
        association: [String: Any],
        logo: PickedFile?,
        certificate: PickedFile?,
        accessToken: String
    ) async throws -> AssociationResponse? {
        try await manager.request(AssociationsApi.register(association: association, logo: logo, certificate: certificate, accessToken: accessToken))
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
}

// MARK: - Membership
extension AssociationsServiceImpl {
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

// MARK: - Enrollment / Membership
extension AssociationsServiceImpl {
    
    public func enrollIntoAssociation(associationId: Int, accessToken: String) async throws -> AssociationMemberResponse? {
        // Assuming your API has a corresponding enroll endpoint
        try await manager.request(
            AssociationsApi.enrollIntoAssociation(associationId: associationId, accessToken: accessToken)
        )
    }
    
    public func cancelMembership(memberId: Int, comment: String, accessToken: String) async throws -> AssociationMemberResponse? {
        // Assuming your API has a corresponding cancel endpoint
        try await manager.request(
            AssociationsApi.cancelMembershipRequest(memberId: memberId, comment: comment, accessToken: accessToken)
        )
    }
    
    public func generateAssociationCode(name: String) -> String {
        // Clean name: uppercase, remove non-alphanumeric and non-space, trim, collapse spaces
        let cleanName = name.uppercased()
            .replacingOccurrences(of: "[^A-Z0-9\\s]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        guard !cleanName.isEmpty else { return "ASC" } // Default fallback
        
        let words = cleanName.split(separator: " ")
        let code: String
        
        switch words.count {
        case 3...:
            code = "\(words[0].first!)\(words[1].first!)\(words[2].first!)"
        case 2:
            let firstChar = words[0].first!
            let nextChars = words[1].prefix(2)
            code = "\(firstChar)\(nextChars)"
        default:
            code = String(cleanName.prefix(3))
        }
        
        return code.padding(toLength: 3, withPad: "X", startingAt: 0)
    }
}

extension AssociationsServiceImpl {
    public func getAssociationProducts(id: Int, page: Int, count: Int, accessToken: String) async throws -> PagedResult<[ProductResponseV1]> {
        let envelope = try await manager.request(AssociationsApi.getAssociationProducts(id: id, page: page, count: count, accessToken: accessToken))

        return envelope.toPagedResult()
    }
}
