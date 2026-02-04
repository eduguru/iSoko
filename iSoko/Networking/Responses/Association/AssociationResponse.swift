//
//  AssociationResponse.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

public struct AssociationResponse: Codable {
    public let id: Int?
    public let name: String?
    public let code: String?
    public let description: String?
    public let manager: PersonContact?
    public let emailAddress: String?
    public let phoneNumber: String?
    public let physicalAddress: String?
    public let country: IDNamePairInt?
    public let website: String?
    public let instagram: String?
    public let linkedin: String?
    public let x: String?
    public let members: Int?
    public let foundedIn: String?
    public let reviewComment: String?
    public let reviewer: PersonContact?
    public let datetimeCreated: String?
    public let datetimeApproved: String?
    public let status: String?
    public let registrationStatus: String?
    public let documents: [AssociationDocument]?
}


public struct Contact: Codable {
    public let id: Int?
    public let email: String?
    public let phoneNumber: String?
}

public struct AssociationDocument: Codable {
    public let id: Int?
    public let title: String?
    public let description: String?
    public let document: String?
}

public struct PersonContact: Codable {
    public let id: String?
    public let email: String?
    public let phoneNumber: String?
    public let firstName: String?
    public let lastName: String?
}

