//
//  OrganizationProfile.swift
//  
//
//  Created by Edwin Weru on 18/11/2025.
//

public struct OrganizationProfile: Codable {
    public let id: Int
    public let email: String
    public let organizationName: String
    public let organizationType: IDNamePairInt
    public let organizationSize: IDNamePairInt
    public let postalAddress: String
    public let physicalAddress: String
    public let website: String?
    public let firstName: String
    public let middleName: String?
    public let lastName: String
    public let phoneNumber: String
    public let username: String
    public let gender: IDNamePairInt
    public let role: IDNamePairInt
    public let location: IDNamePairString
    public let country: IDNamePairInt
    public let status: String
    public let verified: Bool
    public let datetimeCreated: String
}
