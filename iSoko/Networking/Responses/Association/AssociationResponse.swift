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
    
    public let logo: String?
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


// MARK: - Tolerant decoding
// Spec says `foundedIn` is an integer while this model keeps it as a String for display.
// Accept either so one unexpected type never fails the whole association list.
public extension AssociationResponse {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        name = try c.decodeIfPresent(String.self, forKey: .name)
        code = try c.decodeIfPresent(String.self, forKey: .code)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        manager = try c.decodeIfPresent(PersonContact.self, forKey: .manager)
        emailAddress = try c.decodeIfPresent(String.self, forKey: .emailAddress)
        phoneNumber = try c.decodeIfPresent(String.self, forKey: .phoneNumber)
        physicalAddress = try c.decodeIfPresent(String.self, forKey: .physicalAddress)
        country = try c.decodeIfPresent(IDNamePairInt.self, forKey: .country)
        website = try c.decodeIfPresent(String.self, forKey: .website)
        instagram = try c.decodeIfPresent(String.self, forKey: .instagram)
        linkedin = try c.decodeIfPresent(String.self, forKey: .linkedin)
        x = try c.decodeIfPresent(String.self, forKey: .x)
        members = try c.decodeIfPresent(Int.self, forKey: .members)
        if let year = try? c.decodeIfPresent(Int.self, forKey: .foundedIn) {
            foundedIn = String(year)
        } else {
            foundedIn = try c.decodeIfPresent(String.self, forKey: .foundedIn)
        }
        reviewComment = try c.decodeIfPresent(String.self, forKey: .reviewComment)
        reviewer = try c.decodeIfPresent(PersonContact.self, forKey: .reviewer)
        datetimeCreated = try c.decodeIfPresent(String.self, forKey: .datetimeCreated)
        datetimeApproved = try c.decodeIfPresent(String.self, forKey: .datetimeApproved)
        status = try c.decodeIfPresent(String.self, forKey: .status)
        registrationStatus = try c.decodeIfPresent(String.self, forKey: .registrationStatus)
        documents = try c.decodeIfPresent([AssociationDocument].self, forKey: .documents)
        featured = try c.decodeIfPresent(Bool.self, forKey: .featured)
        logo = try c.decodeIfPresent(String.self, forKey: .logo)
    }
}
