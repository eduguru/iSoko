//
//  ServiceProviderResponse.swift
//  
//
//  Created by Edwin Weru on 16/03/2026.
//

import Foundation

public struct ServiceProviderResponse: Codable {
    public let id: Int
    public let organization: String
    public let phoneNumbers: [String]?
    public let originCountry: String?
    public let locations: [Location]?
    public let operatingCountries: [OperatingCountry]?
    public let description: String?
    public let postalAddress: String?
    public let physicalAddress: String?
    public let website: String?
    public let isActive: Bool?
    public let bannerImageUrl: String?
    public let profileImageUrl: String?
    public let organizationEmail: String?
    public let serviceProviderTypeId: Int?
    public let serviceProviderType: String?

    // MARK: - Nested structs
    public struct Location: Codable {
        public let name: String
        public let code: String
        public let isActive: Bool?
    }

    public struct OperatingCountry: Codable {
        public let name: String
        public let code: String
        public let isActive: Bool?
    }
}
