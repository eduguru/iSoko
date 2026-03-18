//
//  AssociationResponse.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

import Foundation

// MARK: - Association Response
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
    public let featured: Bool?
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

public extension AssociationDocument {
    var documentURL: URL? {
        guard let document else { return nil }
        return URL(string: document)
    }
}


public struct PersonContact: Codable {
    public let id: String?
    public let email: String?
    public let phoneNumber: String?
    public let firstName: String?
    public let lastName: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, email, phoneNumber, firstName, lastName
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle id as Int OR String
        if let intId = try? container.decode(Int.self, forKey: .id) {
            self.id = String(intId)
        } else {
            self.id = try? container.decode(String.self, forKey: .id)
        }
        
        self.email = try? container.decode(String.self, forKey: .email)
        self.phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
    }
}

public extension PersonContact {
    var fullName: String {
        [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}
