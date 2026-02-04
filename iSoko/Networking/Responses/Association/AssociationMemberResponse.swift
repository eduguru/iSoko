//
//  AssociationMemberResponse.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

public struct AssociationMemberResponse: Codable {
    public let id: Int
    public let user: Contact?
    public let association: IDNamePairInt?
    public let reviewer: Contact?
    public let reviewComent: String?
    public let status: ReviewStatus?
}

public struct ReviewStatus: Codable {
    public let status: String?
}
